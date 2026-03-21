{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # terminal text editor
    neovim

    # version control
    git

    # network utils
    wget
    curl

    # terminal multiplexer
    tmux

    # wayland clipboard
    wl-clipboard

    # system info
    fastfetch

    ripgrep
    fd
    unzip
    python3
  ];
}
