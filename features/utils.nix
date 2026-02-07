let
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
  osFeatures = host: fes: keepOnlyExisting ((map (fe: ./${fe}/os.nix) (fes ++ [/.])) ++ (map (fe: ./${fe}/os.${host}.nix) (fes ++ [/.])));
  homeFeatures = host: fes: keepOnlyExisting ((map (fe: ./${fe}/home.nix) (fes ++ [/.])) ++ (map (fe: ./${fe}/home.${host}.nix) (fes ++ [/.])));
in rec
{
  getHomeFeatures = host: features: {
    home-manager.users = {
      gabe = {
        imports = homeFeatures host features;
        home = {
          username = "gabe";
          homeDirectory = "/home/gabe";
        };
      };
    };
  };
  getOsFeatures = host: features: {
    imports = osFeatures host features;
  };
  getFeatures = host: features: (getHomeFeatures host features) // (getOsFeatures host features);
}
