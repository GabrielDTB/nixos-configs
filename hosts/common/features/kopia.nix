{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "kopia";
  body = {
    environment.systemPackages = with pkgs; [
      kopia
    ];
  };
}
