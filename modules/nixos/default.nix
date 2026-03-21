{ config, lib, pkgs, ... }:

{
  imports = [
    ./intel.nix
    ./audio.nix
    ./desktop.nix
    ./packages.nix
    ./firewall.nix
    ./vpn.nix
  ];
}
