{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # для Steam/Proton
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
