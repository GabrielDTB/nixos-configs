let
  parts = name: builtins.filter builtins.isString (builtins.split "\\." name);
  tagsOf = ps: builtins.genList (i: builtins.elemAt ps (i + 1)) (builtins.length ps - 2);
  featureFiles = kind: tags: fe: let
    dir = ./${fe};
    select = name: let
      ps = parts name;
      n = builtins.length ps;
    in
      n >= 2
      && builtins.head ps == kind
      && builtins.elemAt ps (n - 1) == "nix"
      && builtins.all (t: builtins.elem t tags) (tagsOf ps);
  in
    if builtins.pathExists dir
    then map (name: dir + "/${name}") (builtins.filter select (builtins.attrNames (builtins.readDir dir)))
    else [];
  featurePaths = kind: tags: fes: builtins.concatMap (featureFiles kind tags) (fes ++ [/.]);
in rec
{
  getStandaloneFeatures = user: specials: features: {
    imports = featurePaths "home" ([user] ++ specials) features;
    home = {
      username = user;
      homeDirectory = "/home/${user}";
    };
  };
  getNixosFeatures = user: specials: features: {
    imports = featurePaths "os" ([user] ++ specials) features;
    home-manager.users.${user} = getStandaloneFeatures user specials features;
  };
}
