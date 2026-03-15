{ config, lib, pkgs, ... }:

let
  theme = import ./theme.nix;
  # strip # for foot (it doesn't use #)
  strip = s: lib.removePrefix "#" s;
in
{
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita-dark";
  };

  services.mako = {
    enable = true;
    settings.default-timeout = 5000;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "${theme.font}:size=12";
        pad = "4x4";
      };
      cursor = {
        style = "block";
      };
      tweak = {
        grapheme-shaping = "yes";
      };
      colors-dark = {
        background = strip theme.bg;
        foreground = strip theme.fg;
      };
      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
      };
    };
  };
}
