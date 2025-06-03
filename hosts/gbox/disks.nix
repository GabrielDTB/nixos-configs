{pkgs, ...}: {
  boot.initrd.luks.devices = {
    "enclave" = {
      device = "/dev/disk/by-label/enc";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=@" "compress-force=zstd:3" "noatime"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["defaults"];
    };
    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=@home" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Enclave" = {
      device = "/dev/disk/by-label/enclave";
      fsType = "btrfs";
      options = ["subvol=@gabe" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Games" = {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@games" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Videos" = {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = ["subvol=@videos" "compress-force=zstd:3" "noatime"];
    };
  };
}
