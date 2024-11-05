{inputs}: let
  inherit (inputs.nixpkgs) lib;
in rec {
  pkgsFor = lib.genAttrs (import inputs.systems) (
    system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
  );
  forEachSystem = f: lib.genAttrs (import inputs.systems) (system: f pkgsFor.${system});
}
