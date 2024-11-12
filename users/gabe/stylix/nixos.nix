{
  lib,
  inputs,
  pkgs,
  ...
}: let
  fromNerdfonts = with pkgs; font: (nerdfonts.override {fonts = [font];});
in {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
    image = ./eighanface.png;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/primer-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/colors.yaml";
    override = {
      base00 = "0c0c0c";
      base01 = "2f2f2f";
      base02 = "535353";
      base03 = "767676";
      base04 = "b9b9b9";
      base05 = "cccccc";
      base06 = "dfdfdf";
      base07 = "f2f2f2";
      base09 = "ff69b4";
      base0D = "1080ff";
      # base0D = "1A8EF3";
    };
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    fonts = with pkgs; {
      serif = {
        package = noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = fromNerdfonts "FiraCode";
        name = "Fira Code Nerd Font";
      };
      # monospace = {
      #   package = monaspace;
      #   name = "Monaspace Neon";
      # };

      emoji = {
        package = noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 1.0;
      terminal = 1.0;
    };
  };
}
