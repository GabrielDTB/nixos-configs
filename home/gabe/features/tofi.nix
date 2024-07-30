{mkFeature, ...}:
mkFeature {
  name = "tofi";
  body = {
    programs.tofi = {
      enable = true;
    };
  };
}
