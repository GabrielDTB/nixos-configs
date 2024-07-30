{outputs, ...}: {
  home = {
    username = "gabe";
    homeDirectory = "/home/gabe";
  };

  imports = [
    ./features
  ];

  nixpkgs = with builtins; {
    overlays = attrValues outputs.overlays;

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
}
