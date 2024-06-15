{inputs, outputs, pkgs, ...}: {
  imports = [
    # ./nixpkgs.nix
    # ./software
    # TODO: Remove home manager dependency.
    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);


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

  system.stateVersion = "23.05";
}
