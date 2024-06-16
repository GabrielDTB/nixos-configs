{inputs, outputs, lib, config, pkgs, ...}: {
  imports = [
    # TODO: Remove home manager dependency.
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    # useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs outputs;};
  };

  nixpkgs = {
    overlays = (builtins.attrValues outputs.overlays);
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -sg escape-time 0
    '';
  };

  environment.systemPackages = with pkgs; [
    # Required for basic functioning.
    git
    coreutils-full
    cryptsetup

    # Common utils.
    wget
    curl
    which
    unzip
    zip

    # Editors.
    vim
    neovim
    helix

    # Nicities to have on every system.
    btop
  ];

  system.stateVersion = "23.05";
}
