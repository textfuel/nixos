{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Boot
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationLimit = 3;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  time.timeZone = "Etc/GMT-6";

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 524288000;
    http-connections = 128;
    max-substitution-jobs = 128;
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 15d";
  };
  nixpkgs.config.allowUnfree = true;

  # Zsh
  programs.zsh.enable = true;

  # User
  users.users.roach = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  system.stateVersion = "25.11";
}
