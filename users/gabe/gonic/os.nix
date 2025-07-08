{...}: let
  gp = "/gonic";
in {
  services.gonic = {
    enable = true;
    settings = {
      music-path = gp + "/music";
      podcast-path = gp + "/podcasts";
      playlists-path = gp + "/playlists";
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
