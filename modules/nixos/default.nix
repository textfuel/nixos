{ config, lib, pkgs, ... }:

{
  imports = [
    ./nvidia.nix
    ./audio.nix
    ./desktop.nix
    ./packages.nix
    ./docker.nix
    ./firewall.nix
    ./vpn.nix
  ];
}
