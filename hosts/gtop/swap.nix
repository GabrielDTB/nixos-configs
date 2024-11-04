{...}: {
  fileSystems."/swap" = {
    device = "/dev/disk/by-label/root";
    fsType = "btrfs";
    options = ["subvol=@swap"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 16 * 1024;
    }
  ];

  zramSwap = {
    enable = true;
  };

  boot = {
    resumeDevice = "/dev/disk/by-label/root";
    kernelParams = [
      "resume_offset=3941632" # btrfs inspect-internal map-swapfile -r /swap/swapfile
    ];
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=4500s
  '';
}
