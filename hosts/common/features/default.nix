{...}: let
  features = import ../../../scripts/featuresOf.nix ./default.nix;
in {
  imports = [
    features
  ];
}
