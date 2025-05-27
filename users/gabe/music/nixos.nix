{
  pkgs,
  ...
}: {
  services.gonic = {
    enable = true;
    settings = {
      music-path = "/home/gabe/Videos/gonic/music";
      podcast-path = "/home/gabe/Videos/gonic/podcasts";
      playlists-path = "/home/gabe/Videos/gonic/playlists";
    };
  };
}
