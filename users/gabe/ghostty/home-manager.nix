{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      window-decoration = false;
      font-feature = [
        "calt"
        "liga"
      ];
      resize-overlay-position = "bottom-right";
      font-size = 10;
      confirm-close-surface = false;
    };
  };
}
