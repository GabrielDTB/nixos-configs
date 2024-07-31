{lib, ...}: let
  readDirRecursive = import ./readDirRecursive.nix {inherit lib;};
in
  target:
    with lib;
    with builtins; (filter (path: path != target && (hasSuffix ".nix" (toString path))) (readDirRecursive (dirOf target)))
