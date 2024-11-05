{
  lib,
  inputs,
  ...
}:
{
  home.sessionVariables.NIX_PATH = lib.concatStringsSep ":" (
    lib.mapAttrsToList (key: value: "${key}=${value}") inputs
  );
}
// (import ./shared.nix {inherit lib inputs;})
