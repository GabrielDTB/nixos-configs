{outputs, ...}: {
  nixpkgs = with builtins; {
    overlays = attrValues outputs.overlays;

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
}
