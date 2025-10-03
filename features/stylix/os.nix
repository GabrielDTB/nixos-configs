{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
    image = ./paper_squares.jpg;
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
    };
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
        package = nerd-fonts.fira-code;
        name = "Fira Code Nerd Font Mono";
      };

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
