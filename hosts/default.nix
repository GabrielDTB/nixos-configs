{inputs, outputs, lib}: let
  hosts = {
    "gbox" = ./gbox;
    "gtop" = ./gtop;
  };
  commonModules = import ../modules/common.nix {inherit inputs outputs lib;};
in
lib.mapAttrs (name: path:
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [path] ++ commonModules;
  })
hosts
