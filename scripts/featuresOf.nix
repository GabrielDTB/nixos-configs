importer: {
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
} @ args: let
  familyOf = import ./familyOf.nix args;
  passthrough = args // {mkFeature = import ./mkFeature.nix args;};
in {
  imports = map (path: import path passthrough) (familyOf importer);
}
