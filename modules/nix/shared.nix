{
  lib,
  inputs,
}: {
  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 60d";
    };
    # optimise.automatic = true;
  };
}
