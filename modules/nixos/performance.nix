{ config, lib, pkgs, ... }:

{
  # Zram swap - compressed RAM swap, ~2:1 ratio
  # With 16GB RAM this gives ~8GB effective swap without touching disk
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Earlyoom - kills memory hogs before kernel OOM freezes the system
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    enableNotifications = true;
    extraArgs = [
      "-g" # kill entire process group
      "--avoid" "'^(sway|waybar|foot|pipewire|wireplumber)$'"
      "--prefer" "'^(cc1plus|cc1|c\\+\\+|ld|rustc|cargo|nix-build)$'"
    ];
  };

  # Nix build resource limits
  nix.settings = {
    cores = 8;        # max cores per build job (leave 4 for desktop)
    max-jobs = 2;     # max parallel build jobs
  };

  # Nix daemon scheduling - native NixOS options
  nix.daemonCPUSchedPolicy = "batch";
  nix.daemonIOSchedClass = "idle";

  # Nix daemon - additional cgroup limits
  systemd.services.nix-daemon.serviceConfig = {
    CPUWeight = 20;
    IOWeight = 50;
    MemoryHigh = "75%";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "80%";
    OOMScoreAdjust = 500;
  };

  # I/O scheduler: none for NVMe (best latency), bfq for rotational/SATA
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
    ACTION=="add|change", KERNEL=="sd[a-z]|vd[a-z]", ATTR{queue/scheduler}="bfq"
  '';

  # Kernel tweaks for responsiveness under memory pressure
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;                # aggressive zram usage (valid up to 200 for zram)
    "vm.watermark_boost_factor" = 0;      # reduce kswapd overhead
    "vm.watermark_scale_factor" = 125;    # wake kswapd earlier
    "vm.page-cluster" = 0;               # zram doesn't need readahead
  };
}
