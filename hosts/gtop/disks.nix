{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.initrd.luks.devices = {
    "enclave" = {
      device = "/dev/disk/by-label/enc";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = ["subvol=@" "compress-force=zstd:3" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3579-4B2B";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [];
}