{
  inputs,
  outputs,
  lib,
  config,
  ...
}: {
  imports = [
    ../../features
  ] ++ [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
  };


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
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.05";
}
