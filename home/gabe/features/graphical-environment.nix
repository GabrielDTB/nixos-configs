{mkFeature, ...}:
mkFeature {
  name = "graphical-environment";
  body = {
    features = {
      kitty.enable = true;
      firefox.enable = true;
      pavucontrol.enable = true;
      signal.enable = true;
      obsidian.enable = true;
    };
  };
}
