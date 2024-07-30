{mkFeature, ...}:
mkFeature {
  name = "direnv";
  enableDefault = true;
  body = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
  };
}
