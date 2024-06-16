{pkgs, ...}: {
  imports = [
    ./graphical-environment-minimal
  ];
  
  programs = {
    thunar = {
      enable = true;
      plugins=  with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    file-roller.enable = true;
  };
}
