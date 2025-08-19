{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      window-decoration = false;
      font-feature = [
        "calt"
        "liga"
      ];
      resize-overlay-position = "bottom-right";
      font-size = 10;
      confirm-close-surface = false;
      copy-on-select = false;
    };
  };
  home.packages = with pkgs; [
    viu
  ];
}
