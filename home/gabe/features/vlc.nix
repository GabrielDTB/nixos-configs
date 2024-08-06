{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "vlc";
  enableDefault = true;
  body = {
    home.packages = with pkgs; [
      unstable.vlc
    ];
  };
}
