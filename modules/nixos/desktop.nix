{ config, lib, pkgs, ... }:

{
  # Keyboard layout
  services.xserver.xkb = {
    layout = "us,ru";
    options = "caps:toggle,grp:caps_toggle";
  };

  programs.dconf.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    XDG_SESSION_DESKTOP = "sway";
  };

  # Portals (needed by waybar, screen sharing, etc.)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      sway = {
        default = [ "gtk" "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
  };

  # Login manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-session --asterisks --cmd 'sway --unsupported-gpu'";
        user = "greeter";
      };
    };
  };

  # Hide boot/systemd logs from greetd tty
  boot.kernelParams = [ "console=tty1" ];
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYVTDisallocate = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamescope.enable = true;
  hardware.steam-hardware.enable = true;


}
