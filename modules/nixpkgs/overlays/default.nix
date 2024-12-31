{inputs}: [
  (import ./unstable-packages.nix {inherit inputs;})
  (import ./master-packages.nix {inherit inputs;})
]
