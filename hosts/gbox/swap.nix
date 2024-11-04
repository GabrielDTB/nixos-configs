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

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/enclave";
    fsType = "btrfs";
    options = ["subvol=@swap" "compress-force=zstd:3" "noatime"];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 1024 * 32; # RAM size
    }
  ];

  zramSwap.enable = true;
}
