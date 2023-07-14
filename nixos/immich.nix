{ pkgs, ... }:

{
  services.btrbk.instances = {
    immich-minutes = {
      onCalendar = "*-*-* *:*:00";
      settings = {
        timestamp_format = "long-iso";
        snapshot_preserve_min = "2d";
        volume."/immich" = {
          snapshot_dir = ".snapshots";
          subvolume."data/library".snapshot_name = "library";
          snapshot_create = "onchange";
        };
      };
    };
    immich-hours = {
      onCalendar = "*-*-* *:00:00";
      settings = {
        timestamp_format = "long-iso";
        snapshot_preserve_min = "latest";
        snapshot_preserve = "48h 365d";
        volume."/immich" = {
          snapshot_dir = ".snapshots";
          subvolume."data/library".snapshot_name = "library";
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
    "/immich/data/library" = pkgs.lib.mkForce {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = [ "subvol=@pictures" "noatime" ];
    };
  };
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
