{
  inputs,
  outputs,
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
      lib.mapAttrsToList (name: value: (import
        ./${
          if (lib.hasSuffix ".nix" name)
          then name
          else name + "/default.nix"
        } {inherit mkFeature lib config pkgs inputs outputs;}))
      (lib.filterAttrs (name: value: name != "default.nix" && (lib.hasSuffix ".nix" name || value == "directory"))
        (readDir ./.));
  }
