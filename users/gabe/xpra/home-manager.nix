{pkgs, ...}: {
  home.packages = with pkgs; [
    xpra
  ];
}
