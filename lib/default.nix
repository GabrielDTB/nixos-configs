{inputs}: let
  inherit (inputs.nixpkgs) lib;
  systems = import ./systems.nix {inherit inputs;};
in
  lib
  // {
    inherit (systems) forEachSystem pkgsFor;
    formatter = systems.forEachSystem (pkgs: pkgs.alejandra);
    devShells = systems.forEachSystem (pkgs: import ../shell.nix {inherit pkgs;});
  }
