{
  inputs,
  outputs,
  lib,
}: let
  hosts = {
    "gbox" = ./gbox;
    "gfrm" = ./gfrm;
    "glab" = ./glab;
  };
  commonModules = map (x: x {inherit inputs outputs lib;}) (import ../modules).nixos;
in
  lib.mapAttrs (name: path:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules =
        [
          path
        ]
        ++ commonModules;
    })
  hosts
