{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ../common
    ../gbox/hledger
  ];

  features = {
    graphical-environment.enable = true;
    bluetooth.enable = true;
    steam.enable = true;
    ssh-daemon.enable = true;
  };

  home-manager.users.gabe = {
    features.libreoffice.enable = true;
    features.hyprland = {
      enableSleep = true;
      monitors = [
        "desc:BOE 0x095F, 2256x1504@60, auto, 1.333333"
      ];
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd "hyprland >/dev/null"'';
        user = "greeter";
      };
    };
  };

  networking = {
    hostName = "gtop";
    networkmanager.enable = true;
    extraHosts = ''
      108.35.129.44 gbox
    '';
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    kernelParams = [
      "quiet"
      "nowatchdog"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
