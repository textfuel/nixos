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
        modules-right = [ "pulseaudio" "sway/language" "clock" ];

        "sway/workspaces" = {
          format = "{name}";
        };

        "sway/language" = {
          format = "{}";
          format-en = "EN";
          format-ru = "RU";
        };

        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
          on-click = "exec foot --title pulsemixer pulsemixer";
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
