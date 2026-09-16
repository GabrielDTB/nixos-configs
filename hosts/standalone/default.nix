{
  inputs,
  outputs,
  lib,
}: let
  hosts = {
    "slugbox" = {
      path = ./slugbox;
      system = "x86_64-linux";
    };
  };

  pkgsFor = system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = import ../../modules/nixpkgs/overlays {inherit inputs;};
    };
in
  lib.mapAttrs (
    _name: {
      path,
      system,
    }: let
      pkgs = pkgsFor system;
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          path
          {nix.package = lib.mkDefault pkgs.nix;}
        ];
      }
  )
  hosts
