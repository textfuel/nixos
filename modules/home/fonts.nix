{ config, lib, pkgs, ... }:

let
  theme = import ./theme.nix;
in
{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <alias>
        <family>monospace</family>
        <prefer><family>${theme.font}</family></prefer>
      </alias>
      <alias>
        <family>sans-serif</family>
        <prefer><family>${theme.font}</family></prefer>
      </alias>
    </fontconfig>
  '';
}
