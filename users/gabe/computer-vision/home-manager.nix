{pkgs, ...}: let
  pkgsP = with pkgs;
    pkgs
    // {
      colmap = colmap.override {
        freeimage = freeimage.overrideAttrs (old: {
          meta = old.meta // {knownVulnerabilities = [];};
        });
      };
    };
in {
  home.packages = with pkgsP; [
    colmap
  ];
}
