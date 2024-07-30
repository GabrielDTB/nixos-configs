{mkFeature, ...}:
mkFeature {
  name = "nixos";
  body = {
    home.shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      nrb = "sudo nixos-rebuild boot";
    };
  };
}
