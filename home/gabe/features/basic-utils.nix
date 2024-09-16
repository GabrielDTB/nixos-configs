{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "basic-utils";
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
