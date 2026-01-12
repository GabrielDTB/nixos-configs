{pkgs, ...}: {
  programs = {
    xfconf.enable = true; # For saving config.
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
