{inputs, outputs, ...}: {
  # system = "x86_64-linux";
  imports = [
    ./nixpkgs.nix
    ./software
  
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.users.gabe = {
        imports = [../../../home];
      };
      home-manager.extraSpecialArgs = {inherit inputs outputs;};
    }

    ({pkgs, ...}: {
      nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
      environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
    })
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };

  system.stateVersion = "23.05";
}