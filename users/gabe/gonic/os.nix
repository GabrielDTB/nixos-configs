{...}: let
  gp = "/gonic";
in {
  services.gonic = {
    enable = true;
    settings = {
      music-path = gp + "/music";
      podcast-path = gp + "/podcasts";
      playlists-path = gp + "/playlists";
      listen-addr = "100.64.0.5:4747";
    };
  };
  fileSystems = {
    ${gp} = {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = ["subvol=@gonic" "compress-force=zstd:3" "noatime"];
    };
  };
}
