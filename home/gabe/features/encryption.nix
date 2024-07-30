{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "encryption";
  enableDefault = true;
  body = {
    home.packages = with pkgs; [
      cryptsetup
    ];
  };
}
