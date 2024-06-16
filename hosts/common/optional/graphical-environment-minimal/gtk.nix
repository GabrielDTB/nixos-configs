{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dracula-theme
    gnome3.adwaita-icon-theme
  ];
}
