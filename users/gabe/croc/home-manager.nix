{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.croc
  ];
}
