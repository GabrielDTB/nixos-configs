{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "osu";
  body = {
    environment.systemPackages = with pkgs; [
      unstable.osu-lazer-bin
    ];
    hardware.opentabletdriver.enable = true;
  };
}
