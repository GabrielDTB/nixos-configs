{pkgs, ...}: {
  home.packages = with pkgs; [
    snapper-gui
  ];
}
