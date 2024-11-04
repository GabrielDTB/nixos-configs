{inputs, outputs, lib}: [
  inputs.home-manager.nixosModules.home-manager
  {
    home-manager.extraSpecialArgs = {inherit inputs outputs;};
  }

  inputs.nixos-cosmic.nixosModules.default
  {
    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = [
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };
  }

  inputs.stylix.nixosModules.stylix

  {
    nixpkgs = {
      overlays = outputs.overlays;
      config.allowUnfree = true;
    };
  }

  {
    nix = with lib; {
      registry = mapAttrs (_: value: {flake = value;}) inputs;
      nixPath = mapAttrsToList (key: value: "${key}=${value}") inputs;

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
]
