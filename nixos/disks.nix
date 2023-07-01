
{ config, pkgs, ... }:

{
  systemd.services = {
    create-swapfile = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "swap-swapfile.swap" ];
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

  fileSystems."/" = pkgs.lib.mkForce {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd:3" "noatime" ];
  };

  fileSystems."/boot" = pkgs.lib.mkForce {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "defaults" ];
  };

  boot.initrd.luks.devices."enclave".device = pkgs.lib.mkForce "/dev/disk/by-label/enc";
  fileSystems."/swap" = pkgs.lib.mkForce {
    device = "/dev/disk/by-label/enclave";
    fsType = "btrfs";
    options = [ "subvol=@swap" "compress=zstd:3" "noatime" ];
  };
  swapDevices = pkgs.lib.mkForce [
    {
      device = "/swap/swapfile";
      size = (1024 * 32); # RAM size
    }
  ]; 
}
