{lib, ...}: let
  helper = base:
    with lib;
    with builtins;
      flatten
      (
        mapAttrsToList
        (
          name: value: let
            path = base + ("/" + name);
          in
            if (value == "directory")
            then helper path
            else path
        )
        (readDir base)
      );
in
  path: (helper path)
