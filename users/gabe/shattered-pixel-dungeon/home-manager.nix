{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.shattered-pixel-dungeon
  ];
}
