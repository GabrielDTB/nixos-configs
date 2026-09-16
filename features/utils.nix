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
  getStandaloneFeatures = host: user: features: {
    imports = homeFeatures host features;
    home = {
      username = user;
      homeDirectory = "/home/${user}";
    };
  };
  getNixosFeatures = host: user: features:
    {imports = osFeatures host features;}
    // {
      home-manager.users.${user} = (getStandaloneFeatures host user features);
    };
}
