{pkgs, ...}: {
  home.packages = with pkgs; [
    zrythm
    ardour
    surge-XT
    carla
  ];
}
