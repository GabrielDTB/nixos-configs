{
  pkgs,
  inputs,
  outputs,
  ...
}: let
  features = map (x: ../../users/gabe + x) [
    /.
    /basic-utils
    /btop
    /core-replacements
    /cosmic
    /croc
    /direnv
    /firefox
    /git
    /helix
    /hledger
    /lazygit
    /libreoffice
    /mpv
    /nixos-aliases
    /osu
    /shattered-pixel-dungeon
    /signal
    /ssh-from
    /ssh-from/gtop
    /steam
    /stylix
    /syncthing
    /tmux
    /virtualization
    /zsh
  ];
in {
  imports =
    [
      ./hardware-configuration.nix
      ./disks.nix
      ./kopia.nix
      ./immich

      ../common
    ]
    ++ (map (x: (import x).nixos or {}) features);

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users.gabe = {
      imports = map (x: (import x).home-manager or {}) features;
      home = {
        username = "gabe";
        homeDirectory = "/home/gabe";
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

  programs.noisetorch.enable = true;

  # services.foldingathome = {
  #   # for heating during winter
  #   enable = true;
  #   daemonNiceLevel = 19;
  # };

  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  #   "L+    /opt/rocm/icd   -    -    -     -    ${pkgs.rocmPackages.clr.icd}"
  # ];

  # services.xmrig = {
  #   enable = true;
  #   package = pkgs.unstable.xmrig;
  #   settings = {
  #     autosave = true;
  #     cpu = {
  #       enable = true;
  #       priority = 1;
  #       max-threads-hint = 33;
  #     };
  #     opencl = false;
  #     # opencl = {
  #     #   enabled = true;
  #     #   # loader = "/opt/rocm/icd/etc/OpenCL/vendors/amdocl64.icd";
  #     #   loader = "/opt/rocm/hip/lib/libOpenCL.so";
  #     #   # platform = "AMD Accelerated Parallel Processing";
  #     #   platform = 0;
  #     # };

  #     cuda = false;
  #     pools = [
  #       {
  #         url = "pool.supportxmr.com:443";
  #         user = "42GtCTb4TzYSKQYyRNihd9bUAwAwjngFq32zEQbz7TkJ9ZSoEAtZKEkYg85TwVLktRiiQ2HwT3MoRXBX6DRuiyyo15YswNS";
  #         pass = "snowbound3326";
  #         keepalive = true;
  #         tls = true;
  #       }
  #     ];
  #     # priority = 1;
  #   };
  # };

  # hardware.opengl.extraPackages = with pkgs; [
  #   rocmPackages.clr.icd
  # ];

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
    extraPackages = with pkgs; [
      mesa.drivers
      rocm-opencl-icd
      rocmPackages.clr.icd
    ];
  };

  services.udev = {
    packages = [
      pkgs.android-udev-rules
    ];
    extraRules = ''
      SUBSYSTEM=="input", ATTRS{name}=="Wireless Controller", MODE="0666", SYMLINK+="dualshock4-bt"
      SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
      SUBSYSTEM=="input", ATTRS{name}=="*Controller Touchpad", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
    '';
  };
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
    unstable.lutris
    zathura
    clinfo
  ];

  zramSwap.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.05";
}
