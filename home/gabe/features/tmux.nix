{mkFeature, ...}:
mkFeature {
  name = "tmux";
  enableDefault = true;
  body = {
    programs.tmux = {
      enable = true;
      escapeTime = 0;
    };
  };
}
