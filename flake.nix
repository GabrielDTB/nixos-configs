{
  description = "Unified system configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hardware.url = "github:nixos/nixos-hardware";
    systems.url = "github:nix-systems/default-linux";
    stylix.url = "github:danth/stylix/release-24.11";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    lib = import ./lib {inherit inputs;};
  in {
    inherit lib;
    inherit (lib) formatter devShells;

    nixosConfigurations = import ./hosts {inherit inputs outputs lib;};
  };
}
