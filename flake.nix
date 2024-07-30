{
  description = "Unified system configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hardware.url = "github:nixos/nixos-hardware";
    systems.url = "github:nix-systems/default-linux";

    rust-overlay.url = "github:oxalica/rust-overlay";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    rust-overlay,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;

    lib = nixpkgs.lib // home-manager.lib;

    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    overlays = import ./overlays {inherit inputs outputs;};
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = with lib; {
      "gbox" = nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/gbox
        ];
      };
      "gtop" = nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/gtop
        ];
      };
    };
  };
}
