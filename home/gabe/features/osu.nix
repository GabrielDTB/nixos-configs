{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "osu";
  body = {
    home.packages = with pkgs; [
      unstable.osu-lazer-bin
    ];
  };
}
