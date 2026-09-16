{
  lib,
  inputs,
  ...
}: {
  imports = [(import ./shared.nix {inherit lib inputs;})];

  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value}") inputs;
}
