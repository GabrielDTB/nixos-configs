{mkFeature, ...}:
mkFeature {
  name = "starship";
  enableDefault = true;
  body = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };
}
