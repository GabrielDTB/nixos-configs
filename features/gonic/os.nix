{...}: let
  gp = "/gonic";
in {
  systemd.services.gonic.serviceConfig.PrivateTmp = true;
  services.gonic = {
    enable = true;
    settings = {
      music-path = gp + "/music";
      podcast-path = gp + "/podcasts";
      playlists-path = gp + "/playlists";
      listen-addr = "100.64.0.5:4747";
      exclude-pattern = "@eaDir|[aA]rtwork|[cC]overs|[sS]cans|[sS]pectrals|.snapshots";
    };
  };
  fileSystems = {
    ${gp} = {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = ["subvol=@gonic" "compress-force=zstd:3" "noatime"];
    };
    "/home/gabe/Videos/beets/library_mount" = {
      device = "/home/gabe/Videos/qbittorrent/RED";
      fsType = "none";
      options = [ "bind" "ro" ];
    };
  };
}
