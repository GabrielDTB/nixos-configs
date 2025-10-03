{pkgs, ...}: {
  home.packages = with pkgs; [
    master.osu-lazer-bin
  ];
}
