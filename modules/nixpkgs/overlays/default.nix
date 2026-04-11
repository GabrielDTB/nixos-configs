{inputs}: [
  (import ./master-packages.nix {inherit inputs;})
  inputs.claude-sandboxed.overlays.default
]
