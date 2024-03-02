{pkgs, ...}: {
  services.btrbk.instances = {
    immich-hours = {
      onCalendar = "*-*-* *:00:00";
      settings = {
        timestamp_format = "long-iso";
        snapshot_preserve_min = "latest";
        snapshot_preserve = "48h 365d";
        volume."/vms" = {
          snapshot_dir = ".snapshots";
        };
      };
    };
  };
  fileSystems = {
    "/vms" = pkgs.lib.mkForce {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = ["subvol=@vms" "noatime"];
    };
  };
}
