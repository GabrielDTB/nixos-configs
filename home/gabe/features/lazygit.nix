{mkFeature, ...}:
mkFeature {
  name = "lazygit";
  enableDefault = true;
  body = {
    programs.lazygit = {
      enable = true;
    };
  };
}
