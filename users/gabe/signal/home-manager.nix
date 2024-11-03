{pkgs, ...}: {
  home.packages = with pkgs; [
    unstable.signal-desktop
  ];
}
