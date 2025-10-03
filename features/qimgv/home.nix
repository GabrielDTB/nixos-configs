{pkgs, ...}: {
  home.packages = with pkgs; [
    qimgv
  ];
}
