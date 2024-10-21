{outputs, lib, ...}: {
  home = {
    username = "gabe";
    homeDirectory = "/home/gabe";
  };

  imports = [
    ./features
  ];

  features = {
    basic-utils.enable = true;
    syncthing.enable = true;
  };

  nixpkgs = with builtins; {
    overlays = attrValues outputs.overlays;

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "kitty";
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
