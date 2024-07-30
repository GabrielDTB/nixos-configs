{mkFeature, ...}:
mkFeature {
  name = "kitty";
  body = {
    programs.kitty.enable = true;
  };
}
