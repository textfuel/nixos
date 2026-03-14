{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.roach.extraGroups = [ "docker" ];
}
