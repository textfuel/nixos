{ config, lib, pkgs, menus, ... }:

let
  theme = import ./theme.nix;
in
{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    extraOptions = [ "--unsupported-gpu" ];
    config = {
      bindkeysToCode = true;
      modifier = "Mod4";
      terminal = "foot";
      menu = "foot -e fsel";

      fonts = {
        names = [ theme.font ];
        size = 11.0;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:caps_toggle";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };

      output = {
        "*" = {
          mode = "1920x1080@144Hz";
        };
      };

      # No gaps, no borders, no title bars
      gaps.inner = 0;
      gaps.outer = 0;
      window.border = 0;
      floating.border = 0;
      window.titlebar = false;
      floating.titlebar = false;

      # Focus doesn't follow mouse
      focus.followMouse = false;

      bars = [];

      startup = [
        { command = "systemctl --user set-environment XDG_CURRENT_DESKTOP=sway && systemctl --user import-environment WAYLAND_DISPLAY && systemctl --user restart xdg-desktop-portal && waybar"; }
      ];

      keybindings = let
        mod = "Mod4";
        enRun = cmd: "exec swaymsg input type:keyboard xkb_switch_layout 0 && ${cmd}";
      in {
        # Universal copy/paste (Ctrl+Shift+C/V for foot, Ctrl+C/V for others)
        "${mod}+c" = "exec sh -c 'if [ \"$(swaymsg -t get_tree | jq -r \".. | select(.focused?) | .app_id\")\" = \"foot\" ]; then wtype -M ctrl -M shift -k c -m shift -m ctrl; else wtype -M ctrl -k c -m ctrl; fi'";
        "${mod}+v" = "exec sh -c 'if [ \"$(swaymsg -t get_tree | jq -r \".. | select(.focused?) | .app_id\")\" = \"foot\" ]; then wtype -M ctrl -M shift -k v -m shift -m ctrl; else wtype -M ctrl -k v -m ctrl; fi'";

        # Apps
        "${mod}+Return" = "exec foot";
        "${mod}+Escape" = "exec ${menus.power}";
        "${mod}+space" = enRun "foot --title fsel -e fsel";
        "${mod}+Alt+l" = enRun "swaylock";

        # Volume (wob)
        "XF86AudioRaiseVolume" = "exec vol up";
        "XF86AudioLowerVolume" = "exec vol down";
        "XF86AudioMute" = "exec vol mute";
        "XF86AudioMicMute" = "exec vol mic-mute";

        # Media
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";

        # Brightness (wob)
        "XF86MonBrightnessUp" = "exec bright up";
        "XF86MonBrightnessDown" = "exec bright down";

        # Window management
        "${mod}+w" = "kill";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+t" = "floating toggle";
        "${mod}+Shift+t" = "focus mode_toggle";

        # Focus
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Ctrl+Left" = "move left";
        "${mod}+Ctrl+Down" = "move down";
        "${mod}+Ctrl+Up" = "move up";
        "${mod}+Ctrl+Right" = "move right";
        "${mod}+Ctrl+h" = "move left";
        "${mod}+Ctrl+j" = "move down";
        "${mod}+Ctrl+k" = "move up";
        "${mod}+Ctrl+l" = "move right";

        # Browser
        "${mod}+b" = "exec librewolf";

        # Layout
        "${mod}+e" = "layout toggle split";
        "${mod}+s" = "layout stacking";

        # Resize
        "${mod}+Minus" = "resize shrink width 10 px";
        "${mod}+Equal" = "resize grow width 10 px";
        "${mod}+Shift+Minus" = "resize shrink height 10 px";
        "${mod}+Shift+Equal" = "resize grow height 10 px";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";

        # Monitor focus
        "${mod}+Shift+Left" = "focus output left";
        "${mod}+Shift+Down" = "focus output down";
        "${mod}+Shift+Up" = "focus output up";
        "${mod}+Shift+Right" = "focus output right";
        "${mod}+Shift+h" = "focus output left";
        "${mod}+Shift+j" = "focus output down";
        "${mod}+Shift+k" = "focus output up";
        "${mod}+Shift+l" = "focus output right";

        # Move to monitor
        "${mod}+Shift+Ctrl+Left" = "move container to output left";
        "${mod}+Shift+Ctrl+Down" = "move container to output down";
        "${mod}+Shift+Ctrl+Up" = "move container to output up";
        "${mod}+Shift+Ctrl+Right" = "move container to output right";
        "${mod}+Shift+Ctrl+h" = "move container to output left";
        "${mod}+Shift+Ctrl+j" = "move container to output down";
        "${mod}+Shift+Ctrl+k" = "move container to output up";
        "${mod}+Shift+Ctrl+l" = "move container to output right";

        # Screenshots
        "Print" = "exec grim - | wl-copy";
        "Ctrl+Print" = "exec grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy";
        "Alt+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";

      };
    };

    extraConfig = ''
      default_orientation horizontal
      focus_on_window_activation focus
      seat seat0 xcursor_theme Bibata-Modern-Classic 24

      # Firefox PiP
      for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable

      # Pulsemixer float
      for_window [app_id="foot" title="pulsemixer"] floating enable, resize set 800 400

      # fsel launcher float
      for_window [app_id="foot" title="fsel"] floating enable, resize set 900 500

      # Environment
      exec export MOZ_ENABLE_WAYLAND=1
      exec export MOZ_WEBRENDER=1
    '';
  };
}
