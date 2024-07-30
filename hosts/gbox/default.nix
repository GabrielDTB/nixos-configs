{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./immich
    ./hledger

    ../common/global
    ../common/users/gabe
    ../common/users/tamy

    # ../common/optional/developing.nix
    ../common/optional/virtualization.nix
    ../common/optional/ssh.nix
    # ../common/optional/core-replacements.nix
    ../common/optional/graphical-environment-full.nix
    # ../common/optional/zsh.nix
    ../common/optional/stylix
    ../common/optional/git
    # ../common/optional/obsidian
    # ../common/optional/osu
    # ../common/optional/signal
    # ../common/optional/starship
    # ../common/optional/zsh
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.05";

  features = {
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

  programs.ssh.forwardX11 = true;
  services.openssh.settings.X11Forwarding = true;

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
    # Install.WantedBy = [ "default.target" ];
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
  # systemd.services.kopia-er = {
  #   description = "Kopia backup";
  #   after = ["network.target"];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "gabe";
  #     ExecStart = toString (
  #       pkgs.writeShellScript "kopia-backup-script.sh" ''
  #         set -eou pipefail

  #         ${pkgs.kopia}/bin/kopia snapshot create "/home/gabe/Games/SteamLibrary/steamapps/compatdata/1245620/pfx/drive_c/users/steamuser/AppData/Roaming/EldenRing/76561198815520289"
  #       ''
  #     );
  #   };
  #   # Install.WantedBy = [ "default.target" ];
  # };
  # systemd.timers.kopia-er = {
  #   description = "Kopia backup schedule";
  #   timerConfig = {
  #     Unit = "oneshot";
  #     OnBootSec = "5m";
  #     OnUnitActiveSec = "5m";
  #   };
  #   wantedBy = ["timers.target"];
  # };

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
    vlc
    steam
    unstable.croc
    kopia
    lazygit
    qbittorrent
    p7zip
    prismlauncher
    android-udev-rules
    unstable.android-studio
    xboxdrv
    unstable.ghidra
    unstable.imhex
  ];
}
