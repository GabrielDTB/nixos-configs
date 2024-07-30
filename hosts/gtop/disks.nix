{pkgs, ...}: {
  systemd.services.create-swapfile = {
    serviceConfig.Type = "oneshot";
    wantedBy = ["swap-swapfile.swap"];
    script = ''
      swapfile="/swap/swapfile"
      if [[ -f "$swapfile" ]]; then
        echo "Swap file $swapfile already exists, taking no action"
      else
        echo "Setting up swap file $swapfile"
        ${pkgs.coreutils}/bin/truncate -s 0 "$swapfile"
        ${pkgs.e2fsprogs}/bin/chattr +C "$swapfile"
      fi
    '';
  };

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
    "/swap" = {
      device = "/dev/disk/by-label/enclave";
      fsType = "btrfs";
      options = ["subvol=@swap" "compress-force=zstd:3" "noatime"];
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
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 16; # Double RAM size to compensate for low RAM
    }
  ];
}
