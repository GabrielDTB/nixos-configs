{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./immich
    ./hledger

    ../common
  ];

  features = {
    graphical-environment.enable = true;
    bluetooth.enable = true;
    steam.enable = true;
    virtualization.enable = true;
    ssh-daemon.enable = true;
    kopia.enable = true;
    hledger.enable = true;

    tamy.enable = true;
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

  systemd.services.er-backup = {
    description = "Elden Ring backup";
    after = ["network.target"];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "kopia-backup-script.sh" ''
          set -eou pipefail

          ${pkgs.kopia}/bin/kopia snapshot create /home/gabe/Coding/EldenRingComplete
        ''
      );
    };
  };
  systemd.timers.er-backup = {
    description = "Elden ring backup schedule";
    timerConfig = {
      User = "root";
      Unit = "oneshot";
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
    };
    wantedBy = ["timers.target"];
  };

  networking.hostName = "gbox";
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["pcie_acs_override=downstream,multifunction"];

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  time.timeZone = "America/New_York";

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [mesa.drivers rocm-opencl-icd];
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  programs.adb.enable = true;

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  environment.systemPackages = with pkgs; [
    qbittorrent
    p7zip
    prismlauncher
    android-udev-rules
    unstable.android-studio
    xboxdrv
    unstable.ghidra
    unstable.imhex
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.05";
}
