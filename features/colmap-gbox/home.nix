{pkgs, ...}: {
  home.packages = [
    (pkgs.callPackage ./colmap.nix {})
  ];
}
