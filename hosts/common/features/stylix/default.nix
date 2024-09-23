{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "stylix";
  enableDefault = true;
  body = let
    fromNerdfonts = with pkgs; font: (nerdfonts.override {fonts = [font];});
  in {
    stylix = {
      enable = true;
      image = ./EEEEE.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
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
  };
}
