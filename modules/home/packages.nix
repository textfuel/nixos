{ config, lib, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.fsel.packages.${pkgs.stdenv.hostPlatform.system}.default
  ] ++ (with pkgs; [
    nh
    claude-code
    brightnessctl
    playerctl
    lazydocker
    lazygit
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
    pavucontrol
    wdisplays
    wtype
    thunar
    stow
    zinit
    fzf
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
