{pkgs, ...}: {
  home.packages = with pkgs; [
    (colmap.override {
      freeimage = freeimage.overrideAttrs (old: {
        meta = old.meta // {knownVulnerabilities = [];};
      });
    })
  ];
}
