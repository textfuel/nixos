{ config, lib, pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    configPath = ".config/librewolf/librewolf";
    profiles.default = {
      isDefault = true;
      path = "52924dgn.default";
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
        vimium
        stylus
        sidebery
      ];
      settings = {
        # Sidebar on left
        "sidebar.position_start" = true;
        # Enable userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Dark theme
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "layout.css.prefers-color-scheme.content-override" = 0;
        "ui.systemUsesDarkTheme" = 1;

        # Performance
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.capacity" = 524288; # 512MB
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.max-connections" = 1800;
        "network.dns.disablePrefetchFromHTTPS" = false;
        "network.predictor.enabled" = true;
        "network.prefetch-next" = true;
        "network.dns.disablePrefetch" = false;
        "content.notify.interval" = 100000;
      };
      userChrome = ''
        /* Hide native tabs - using Sidebery instead */
        #TabsToolbar {
          visibility: collapse !important;
        }
      '';
    };
  };
}
