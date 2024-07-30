{mkFeature, ...}:
mkFeature {
  name = "btop";
  enableDefault = true;
  body = {
    programs.btop = {
      enable = true;
    };
  };
}
