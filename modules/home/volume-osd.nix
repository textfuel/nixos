{ config, lib, pkgs, ... }:

let
  theme = import ./theme.nix;
  strip = s: lib.removePrefix "#" s;

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

  brightScript = pkgs.writeShellScriptBin "bright" ''
    case "$1" in
      up)   ${pkgs.brightnessctl}/bin/brightnessctl set 5%+ ;;
      down) ${pkgs.brightnessctl}/bin/brightnessctl set 5%- ;;
    esac

    level=$(${pkgs.brightnessctl}/bin/brightnessctl -m | ${pkgs.gawk}/bin/awk -F, '{print substr($4, 0, length($4)-1)}')
    echo "$level" > "$XDG_RUNTIME_DIR/wob.pipe"
  '';
in
{
  home.packages = [ pkgs.wob volScript brightScript ];

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
          ${pkgs.wob}/bin/wob \
            --anchor bottom \
            --margin 30 \
            -W 300 \
            -H 30 \
            -b 2 \
            -p 4 \
            --background-color '#E6${strip theme.bg}' \
            --bar-color '#FF${strip theme.accent}' \
            --border-color '#FF333333' \
            -t 1000
      '');
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
