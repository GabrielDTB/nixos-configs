{...}: {
  boot.initrd.luks.devices = {
    "enclave" = {
      device = "/dev/disk/by-label/enc";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root"; # change label to nixos
      fsType = "btrfs";
      options = ["subvol=@" "compress-force=zstd:3" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3579-4B2B"; # change to use by-label
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/swap" = {
      device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = ["subvol=@swap"];
    };
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
