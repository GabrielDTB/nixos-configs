{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.osu-lazer-bin
  ];
}
