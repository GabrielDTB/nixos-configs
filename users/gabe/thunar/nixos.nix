{pkgs, ...}: {
  programs = {
    xconf.enable = true; # For saving config.
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
