{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ../common
  ];

  features = {
    graphical-environment.enable = true;
    bluetooth.enable = true;
    steam.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        user = "greeter";
      };
    };
  };

  networking.hostName = "gtop";
  networking.networkmanager.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
