{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "basic-utils";
  enableDefault = true;
  body = {
    home.packages = with pkgs; [
      coreutils-full
      wget
      curl
      which
      unzip
      zip
    ];
  };
}
