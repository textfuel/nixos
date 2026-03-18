{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 51413 ]; # transmission
    allowedUDPPorts = [ 51413 ]; # transmission
  };
}
