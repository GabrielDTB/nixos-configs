{
  description = "Unified system configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    hardware.url = "github:nixos/nixos-hardware";
    systems.url = "github:nix-systems/default-linux";
    stylix.url = "github:danth/stylix/8b0d9317edd57c5374adcf6957ae4775875c2a9d";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
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
