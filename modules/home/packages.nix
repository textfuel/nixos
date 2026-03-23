{ config, lib, pkgs, inputs, ... }:

{
  xdg.desktopEntries.lsp-plugins = {
    name = "LSP Plugins";
    noDisplay = true;
  };

  home.packages = [
    inputs.fsel.packages.${pkgs.stdenv.hostPlatform.system}.default
  ] ++ (with pkgs; [
    nh
    claude-code
    brightnessctl
    playerctl
    lazydocker
    lazygit
    chromium
    obs-studio
    spotify
    vesktop
    jq
    zoxide
    btop
    grim
    slurp
    mako
    compsize
    duperemove
    easyeffects
    lsp-plugins
    rnnoise-plugin
    pavucontrol
    wdisplays
    wtype
    thunar
    stow
    zinit
    fzf
    gh
    glab
    sshs

    # Go
    go
    gopls
    delve
    golangci-lint

    # Rust
    rustup

    # Python
    uv
    python3

    # Ruby
    ruby
    mise

    # VPN
    wireguard-tools
    tailscale
    sing-box         # hysteria2, vless, vmess, shadowsocks etc.
    openvpn
    networkmanager-openvpn

    # General dev
    gcc
    gnumake
    pkg-config
    openssl
  ]);
}
