{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "croc";
  enableDefault = true;
  body = {
    home.packages = with pkgs; [
      unstable.croc
    ];
  };
}
