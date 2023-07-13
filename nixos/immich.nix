{ pkgs, ... }:

{
  services.btrbk.instances = {
    immich = {
      onCalendar = "*-*-* *:*:00";
      settings = {
        timestamp_format = "long-iso";
        snapshot_preserve_min = "18h";
        snapshot_preserve = "36h 365d";
        volume."/immich" = {
          snapshot_dir = ".snapshots";
          subvolume."data/library".snapshot_name = "library";
          snapshot_create = "onchange";
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
