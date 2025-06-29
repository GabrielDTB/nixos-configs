{pkgs, ...}: {
  services.gonic = {
    enable = true;
    settings = {
      music-path = "/gonic/music";
      podcast-path = "/gonic/podcasts";
      playlists-path = "/gonic/playlists";
    };
  };
  fileSystems = {
    "/home/gabe/gonic" = {
      device = "/dev/disk/by-label/data";
      fsType = "btrfs";
      options = ["subvol=@gonic" "compress-force=zstd:3" "noatime"];
    };
  };
}
