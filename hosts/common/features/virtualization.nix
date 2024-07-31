{
  pkgs,
  mkFeature,
  ...
}:
mkFeature {
  name = "virtualization";
  body = {
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
    ];
    programs.dconf.enable = true;
  };
}
