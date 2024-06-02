{pkgs, ...}: {
  systemd.services = {
    create-swapfile = {
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
  };

  boot.initrd.luks.devices."enclave".device = pkgs.lib.mkForce "/dev/disk/by-label/enc";

  fileSystems = {
    "/" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=@" "compress-force=zstd:3" "noatime"];
    };
    "/boot" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["defaults"];
    };
    "/swap" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/enclave";
      fsType = "btrfs";
      options = ["subvol=@swap" "compress-force=zstd:3" "noatime"];
    };
    "/home" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=@home" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Enclave" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/enclave";
      fsType = "btrfs";
      options = ["subvol=@gabe" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Games" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@games" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/ml" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@ml" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Videos" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = ["subvol=@videos" "compress-force=zstd:3" "noatime"];
    };
    "/minecraft" = pkgs.lib.mkForce {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@minecraft" "compress-force=zstd:3" "noatime"];
    };
  };

  swapDevices = pkgs.lib.mkForce [
    {
      device = "/swap/swapfile";
      size = 1024 * 32; # RAM size
    }
  ];
}
