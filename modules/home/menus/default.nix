{ config, lib, pkgs, ... }:

let
  dmenu = opts: cmd: pkgs.writeShellScript "dmenu-${cmd.name}" ''
    choice=$(printf '${opts}' | fsel --dmenu --only-match)
    [ -z "$choice" ] && exit 0
    ${cmd.script}
  '';

  dedupAndPoweroff = pkgs.writeShellScript "dedup-poweroff" ''
    sudo duperemove -dr --io-threads="$(nproc)" --hashfile=/var/cache/duperemove.db /
    systemctl poweroff
  '';

  powerMenu = dmenu "dedup & poweroff\npoweroff\nreboot\nsuspend\nlock\nlogout" {
    name = "power";
    script = ''
      case "$choice" in
        "dedup & poweroff") ${dedupAndPoweroff} ;;
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
