{
  userWithFeatures = user: features: let
    keepOnlyExisting = paths:
      with builtins;
        concatLists (
          map
          (path:
            if pathExists path
            then [path]
            else [])
          paths
        );
    bases = map (feature: ../users/${user}/${feature}) features;
    osFeatures = keepOnlyExisting (map (base: /${base}/nixos.nix) bases);
    homeFeatures = keepOnlyExisting (map (base: /${base}/home-manager.nix) bases);
  in
    {...}: {
      imports = osFeatures;
      home-manager.users = {
        ${user} = {
          imports = homeFeatures;
          home = {
            username = user;
            homeDirectory = "/home/${user}";
          };
        };
      };
    };
}
