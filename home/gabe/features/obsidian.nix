{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "obsidian";
  body = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
