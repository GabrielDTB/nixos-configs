{...}: {
  imports = (import ../../modules).home-manager;

  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
}
