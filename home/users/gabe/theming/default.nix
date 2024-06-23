{
  lib,
  pkgs,
  ...
}:
with lib; {
  options.theming = {
    color = {
      background = mkOption {
        type = types.str;
        default = "282c32";
      };
      highlight = mkOption {
        type = types.str;
        default = "61afef";
      };
      text = mkOption {
        type = types.str;
        default = "abb2bf";
      };
      error = mkOption {
        type = types.str;
        default = "e06c75";
      };
    };
    font = {
      monospaced = mkOption {
        type = types.str;
        default = "IosevkaTerm NFM";
      };
    };
  };

  config = {
    home.packages = with pkgs; [
      (nerdfonts.override {fonts = ["Iosevka"];})
    ];
  };

  # config = {
  # };
  # lib.colors.background = "";
  # options = with pkgs.lib.mkOption; {
  # colors = mkOption {
  #   default = {
  #     background = "282c32";
  #     highlight = "61afef";
  #     text = "abb2bf";
  #     error = "e06c75";
  #   };
  # background = mkOption {
  #   default = "282c32";
  # highlight = mkOption {
  #   default = "61afef";
  # };
  # text = "abb2bf";
  # error = "e06c75";
  # };
  # };
  # };
  # config = {
  #   colors = {
  #     background = "282c32";
  #     highlight = "61afef";
  #     text = "abb2bf";
  #     error = "e06c75";
  #   };
  #   font = {
  #     programming = "IosevkaTerm NFM";
  #   };
  # };
}
