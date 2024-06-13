{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = ["kvm-amd"];
      luks.devices."enclave".device =  "/dev/disk/by-label/enc";
      # luks.devices."enclave".device = "/dev/disk/by-uuid/c05994a7-fd1f-4af4-8263-4c054604497d";
    };
  };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/414ff2b5-8a76-4df9-ad8b-2f7cd6dd57c7";
  #   fsType = "btrfs";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/F692-19D3";
  #   fsType = "vfat";
  # };

  # fileSystems."/swap" = {
  #   device = "/dev/disk/by-uuid/666a612e-c2f6-4e37-8c34-c0402aa1e96d";
  #   fsType = "btrfs";
  #   options = ["subvol=@swap"];
  # };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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


  fileSystems = {
    "/" =  {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=@" "compress-force=zstd:3" "noatime"];
    };
    "/boot" =  {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["defaults"];
    };
    "/swap" =  {
      device = "/dev/disk/by-label/enclave";
      fsType = "btrfs";
      options = ["subvol=@swap" "compress-force=zstd:3" "noatime"];
    };
    "/home" =  {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=@home" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Enclave" =  {
      device = "/dev/disk/by-label/enclave";
      fsType = "btrfs";
      options = ["subvol=@gabe" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Games" =  {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@games" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/ml" =  {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@ml" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Videos" =  {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = ["subvol=@videos" "compress-force=zstd:3" "noatime"];
    };
    "/minecraft" =  {
      device = "/dev/disk/by-label/ssd";
      fsType = "btrfs";
      options = ["subvol=@minecraft" "compress-force=zstd:3" "noatime"];
    };
  };

  swapDevices =  [
    {
      device = "/swap/swapfile";
      size = 1024 * 32; # RAM size
    }
  ];
}
