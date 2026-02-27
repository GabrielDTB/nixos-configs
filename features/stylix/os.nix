{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix = {
    enable = true;
    image = ./paper_squares.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
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
        name = "FiraCode Nerd Font Mono";
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
