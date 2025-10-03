{pkgs, ...}: {
  programs.beets = {
    enable = true;
  };
  home.packages = with pkgs; [
    supersonic-wayland
    feishin
  ];
}
