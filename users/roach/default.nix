{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home.username = "roach";
  home.homeDirectory = "/home/roach";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
