{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "obsidian";
  body = {
    home.packages = with pkgs; [
      unstable.obsidian
    ];
  };
}
