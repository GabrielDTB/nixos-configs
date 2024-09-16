{
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  imports =
    [
      ./features
    ]
    ++ [inputs.home-manager.nixosModules.home-manager]
    ++ [inputs.stylix.nixosModules.stylix];

  nixpkgs = with builtins; {
    overlays = attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  nix = with lib; {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
