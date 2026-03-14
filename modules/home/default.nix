{ config, lib, pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./browser.nix
    ./packages.nix
    ./shell.nix
    ./services.nix
    ./fonts.nix
    ./waybar.nix
    ./volume-osd.nix
    ./fsel.nix
    ./menus
  ];
}
