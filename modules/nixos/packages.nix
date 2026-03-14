{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
    tmux
    wl-clipboard
  ];
}
