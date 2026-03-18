{ config, lib, pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" ];
        modules-right = [ "tray" "custom/displays" "pulseaudio" "custom/language" "clock" ];

        "sway/workspaces" = {
          format = "{name}";
        };

        "custom/language" = {
          exec = "swaymsg -t subscribe -m '[\"input\"]' | jq -r --unbuffered '.input.xkb_active_layout_name // empty' | while read -r layout; do echo \"$layout\" | head -c 2 | tr a-z A-Z; echo; done";
          format = "{}";
          tooltip = false;
        };

        "custom/displays" = {
          format = "MON";
          tooltip = false;
          on-click = "exec wdisplays";
        };

        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
          on-click = "exec pavucontrol";
        };

        clock = {
          format = "{:%H:%M}";
        };
      };
    };

    style = ''
      * {
        font-family: "${theme.font}", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: ${theme.bg};
        color: ${theme.fg};
      }

      #workspaces button {
        padding: 0 8px;
        color: ${theme.inactive};
        background: transparent;
      }

      #workspaces button.focused {
        color: ${theme.bg};
        background-color: ${theme.accent};
      }

      #tray {
        padding: 0 10px;
      }

      #custom-displays {
        padding: 0 10px;
        color: ${theme.fg};
      }

      #pulseaudio {
        padding: 0 10px;
        color: ${theme.accent};
      }

      #language,
      #clock {
        padding: 0 10px;
        color: ${theme.fg};
      }
    '';
  };
}
