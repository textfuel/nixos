{ config, lib, pkgs, ... }:

{
  # Tailscale
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # WireGuard kernel module
  boot.kernelModules = [ "wireguard" ];
}
