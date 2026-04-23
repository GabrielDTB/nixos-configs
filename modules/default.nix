let
  modules = [
    ./nix
    ./nixpkgs
    ./claude-sandboxed
  ];
  mergeConfig = type:
    builtins.foldl' (
      acc: module:
        acc ++ [(import module).${type} or ({...}: {})]
    ) []
    modules;
in {
  nixos = mergeConfig "nixos";
  home-manager = mergeConfig "home-manager";
}
