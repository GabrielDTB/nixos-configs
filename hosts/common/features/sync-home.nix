{
  mkFeature,
  ...
}:
mkFeature {
  name = "sync-home";
  body = {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      dataDir = "/home/gabe";
      user = "gabe";
      settings = {
        folders = {
          "Documents" = {
            path = "~/Documents";
            id = "fuedw-hrwrw";
          };
        };
      };
    };
    # Stop syncthing from creating default Sync folder.
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  };
}
