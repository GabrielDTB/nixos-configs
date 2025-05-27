{
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.callPackage ./fze {})
  ];  
}
