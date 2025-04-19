{pkgs, ...}:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    corefonts
    vista-fonts
  ];
}
