{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.callPackage ./colmap.nix {})
    ffmpeg-full
    meshlab
  ];
}
