{mkFeature, ...}:
mkFeature {
  name = "steam";
  body = {
    programs.steam.enable = true;
  };
}
