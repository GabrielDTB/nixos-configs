{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "pavucontrol";
  body = {
    home.packages = with pkgs; [
      pavucontrol
    ];
  };
}
