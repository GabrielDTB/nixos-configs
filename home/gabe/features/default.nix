{
  lib,
  config,
  pkgs,
  ...
}: let
  mkFeature = {
    name,
    enableDefault ? false,
    body,
    ...
  }:
    with lib; {
      options.features.${name} = {
        enable = mkEnableOption name // {default = enableDefault;};
      };

      config = mkIf config.features.${name}.enable body;
    };
in
  with builtins; {
    imports =
      map (name: (import ./${name} {inherit mkFeature lib config pkgs;}))
      (filter (name: name != "default.nix")
        (attrNames (builtins.readDir ./.)));
  }
