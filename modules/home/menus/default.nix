{ config, lib, pkgs, ... }:

let
  dmenu = opts: cmd: pkgs.writeShellScript "dmenu-${cmd.name}" ''
    choice=$(printf '${opts}' | fsel --dmenu --only-match)
    [ -z "$choice" ] && exit 0
    ${cmd.script}
  '';

  powerMenu = dmenu "poweroff\nreboot\nsuspend\nlock\nlogout" {
    name = "power";
    script = ''
      case "$choice" in
        poweroff) systemctl poweroff ;;
        reboot)   systemctl reboot ;;
        suspend)  systemctl suspend ;;
        lock)     swaymsg input type:keyboard xkb_switch_layout 0 && swaylock ;;
        logout)   swaymsg exit ;;
      esac
    '';
  };
in
{
  _module.args.menus = {
    power = "foot --title fsel -e ${powerMenu}";
  };
}
