{pkgs, ...}: {
  programs.beets = {
    enable = true;
  };
  home.packages = with pkgs; [
    feishin
  ];
}
