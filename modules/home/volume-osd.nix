{ config, lib, pkgs, ... }:

let
  theme = import ./theme.nix;
  strip = s: lib.removePrefix "#" s;

  sounds = pkgs.sound-theme-freedesktop;

  volScript = pkgs.writeShellScriptBin "vol" ''
    case "$1" in
      up)   ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0 ;;
      down) ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
      mute) ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
      mic-mute) ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    esac

    info=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@)
    level=$(echo "$info" | ${pkgs.gawk}/bin/awk '{printf "%d", $2 * 100}')

    if echo "$info" | ${pkgs.gnugrep}/bin/grep -q MUTED; then
      echo 0 > "$XDG_RUNTIME_DIR/wob.pipe"
    else
      echo "$level" > "$XDG_RUNTIME_DIR/wob.pipe"
    fi
  '';

  micMuteScript = pkgs.writeShellScriptBin "mic-mute" ''
    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    info=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
    if echo "$info" | ${pkgs.gnugrep}/bin/grep -q MUTED; then
      ${pkgs.pipewire}/bin/pw-play ${sounds}/share/sounds/freedesktop/stereo/device-removed.oga &
    else
      ${pkgs.pipewire}/bin/pw-play ${sounds}/share/sounds/freedesktop/stereo/device-added.oga &
    fi
  '';

  brightScript = pkgs.writeShellScriptBin "bright" ''
    case "$1" in
      up)   ${pkgs.brightnessctl}/bin/brightnessctl set 5%+ ;;
      down) ${pkgs.brightnessctl}/bin/brightnessctl set 5%- ;;
    esac

    level=$(${pkgs.brightnessctl}/bin/brightnessctl -m | ${pkgs.gawk}/bin/awk -F, '{print substr($4, 0, length($4)-1)}')
    echo "$level" > "$XDG_RUNTIME_DIR/wob.pipe"
  '';

  wobConfig = pkgs.writeText "wob.ini" ''
    anchor = top
    margin = 30
    width = 300
    height = 30
    border_size = 2
    bar_padding = 4
    bar_color = ${strip theme.accent}FF
    background_color = ${strip theme.bg}E6
    border_color = 333333FF
    timeout = 1000
  '';
in
{
  home.packages = [ pkgs.wob volScript brightScript micMuteScript ];

  systemd.user.services.wob = {
    Unit = {
      Description = "Wayland Overlay Bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = toString (pkgs.writeShellScript "wob-start" ''
        rm -f "$XDG_RUNTIME_DIR/wob.pipe"
        mkfifo "$XDG_RUNTIME_DIR/wob.pipe"
        tail -f "$XDG_RUNTIME_DIR/wob.pipe" | \
          ${pkgs.wob}/bin/wob -c ${wobConfig}
      '');
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
