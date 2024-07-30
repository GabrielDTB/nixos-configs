{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "thunar";
  body = {
    home.packages = with pkgs; [
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      gnome.file-roller
      gnome.gvfs
    ];
  };
}
