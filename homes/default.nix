{
  inputs,
  outputs,
  lib,
}: let
  # Standalone home-manager targets: machines whose OS we don't manage, so only
  # the home.nix half of each feature applies. The attribute name doubles as the
  # host name used for per-host feature overrides (features/*/home.<host>.nix),
  # so it has to match the string passed to getHomeImports in <name>/default.nix.
  homes = {
    "generic" = {
      path = ./generic;
      system = "x86_64-linux";
      username = "gabe";
      homeDirectory = "/home/gabe";
    };
  };

  # nixpkgs.overlays and nixpkgs.config set from inside a home-manager module are
  # silently dropped when pkgs is handed to homeManagerConfiguration, so what
  # modules/nixpkgs would have applied has to be baked into pkgs here instead.
  pkgsFor = system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = import ../modules/nixpkgs/overlays {inherit inputs;};
    };

  mkHome = {
    path,
    system,
    username,
    homeDirectory,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system;
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [
        path
        {home = {inherit username homeDirectory;};}
      ];
    };
in
  # Exposed under both the bare name and the home-manager convention, so either
  # `--flake .#generic` or `--flake .#gabe@generic` works.
  lib.concatMapAttrs (name: home: let
    configuration = mkHome home;
  in {
    ${name} = configuration;
    "${home.username}@${name}" = configuration;
  })
  homes
