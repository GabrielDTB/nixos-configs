{ pkgs, ... }:

{
  services.btrbk = {
    instances.immich = {
      onCalendar = "*-*-* *:*:00";
      settings = {
        timestamp_format = "long-iso";
        snapshot_preserve_min = "18h";
        snapshot_preserve = "36h 365d";
        volume = {
          "/immich" = {
            snapshot_dir = ".snapshots";
            subvolume = "pictures";
            snapshot_create = "onchange";
          };
        };
      };
    };
  };
  fileSystems = {
    "/immich" = pkgs.lib.mkForce {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = [ "subvol=@immich" "noatime" ];
    };
    "/immich/pictures" = pkgs.lib.mkForce {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = [ "subvol=@pictures" "noatime" ];
    };
  };
}
