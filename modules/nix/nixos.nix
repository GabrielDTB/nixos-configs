{
  lib,
  inputs,
  ...
}:
{
  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value}") inputs;
}
// (import ./shared.nix {inherit lib inputs;})
