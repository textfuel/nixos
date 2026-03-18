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

    # btrfs block-level deduplication
    duperemove

    # windows VM in docker
    winboat
    freerdp

    # torrent client
    transmission_4-gtk

    # password manager
    bitwarden-desktop

    # neovim/lazyvim dependencies
    gcc # treesitter compilation
    gnumake
    ripgrep # telescope live grep
    fd # telescope file finder
    nodejs # some LSP servers
    unzip # mason.nvim
    python3 # python LSP support
  ];
}
