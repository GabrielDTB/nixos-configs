{
  pkgs,
  mkFeature,
  ...
}:
mkFeature {
  name = "libreoffice";
  body = {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
