{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix

    ../common/global
    ../common/users/gabe
    ../common/users/tamy

    ../common/optional/graphical-environment-full.nix
    ../common/optional/stylix
    ../common/optional/git
  ];

  features = {
    bluetooth.enable = true;
    steam.enable = true;
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
