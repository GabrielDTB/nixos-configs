{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "signal";
  body = {
    home.packages = with pkgs; [
      unstable.signal-desktop
    ];
  };
}
