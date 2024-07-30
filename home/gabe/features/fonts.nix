{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "fonts";
  enableDefault = true;
  body = {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      babelstone-han
    ];
  };
}
