{
  mkFeature,
  ...
}:
mkFeature {
  name = "syncthing";
  body = {
    services.syncthing.enable = true;
  };
}
