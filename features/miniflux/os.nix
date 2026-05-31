{pkgs, ...}: {
  services.miniflux = {
    enable = true;
    package = pkgs.master.miniflux;
    # Safe to expose since this is only served on my private network.
    adminCredentialsFile = ./userinfo;
    config = {
      LISTEN_ADDR = "100.64.0.5:13914";
    };
  };
}
