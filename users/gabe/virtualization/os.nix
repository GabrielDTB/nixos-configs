{...}: {
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  users.users.gabe = {
    extraGroups = ["libvirtd"];
  };
}
