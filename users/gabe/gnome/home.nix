{pkgs, ...}: {
  programs.gnome-shell = {
    extensions = with pkgs.gnomeExtensions; [
      blur-my-shell
      launch-new-instance
      space-bar
      forge
    ];
  };
  dconf = {
    enable = true;
    settings = {
      # "org/gnome/desktop/interface" = {
      #   clock-show-weekday = true;
      # };
    };
  };
}
