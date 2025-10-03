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
  osFeatures = fes: keepOnlyExisting (map (fe: ./${fe}/os.nix) (fes ++ [/.]));
  homeFeatures = fes: keepOnlyExisting (map (fe: ./${fe}/home.nix) (fes ++ [/.]));
in rec
{
  getHomeFeatures = features: {
    home-manager.users = {
      gabe = {
        imports = homeFeatures features;
        home = {
          username = "gabe";
          homeDirectory = "/home/gabe";
        };
      };
    };
  };
  getOsFeatures = features: {
    imports = osFeatures features;
  };
  getFeatures = features: (getHomeFeatures features) // (getOsFeatures features);
}
