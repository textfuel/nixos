{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
    tmux
    wl-clipboard

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
