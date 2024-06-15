{inputs, pkgs, lib, config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./immich.nix
    ./immich-container.nix
    ./software
    
    ../common/global
    ../common/users/gabe
    ../common/users/tamy

    ../common/optional/developing.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };

  environment.systemPackages = with pkgs; [
    wl-screenrec
    virt-manager
    vim
    neovim
    wget
    btop
    which
    git
    nix-prefetch-scripts
    cryptsetup
    greetd.tuigreet
    helix
    v4l-utils
    ffmpeg-full
    slurp
    grim
    wf-recorder
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
    curl
    gnumake
    clang
    gcc
    valgrind
    coreutils
    unstable.eza
    unzip
    zip
  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -sg escape-time 0
    '';
  };

  programs.zsh.enable = true;
  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["pcie_acs_override=downstream,multifunction"];

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.file-roller.enable = true;
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "America/New_York";
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.dbus.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [mesa.drivers rocm-opencl-icd];
  };
  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -ro";
        };
      };
    };
    config.common.default = "*";
  };
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Make some extra kernel modules available to NixOS
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];

  # Activate kernel modules (choose from built-ins and extra ones)
  boot.kernelModules = [
    # Virtual Camera
    "v4l2loopback"
    # Virtual Microphone, built-in
    "snd-aloop"
  ];

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  programs.adb.enable = true;
  programs.steam.enable = true;
  security.pam.services.swaylock = {};

  # Set initial kernel module settings
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    blacklist nouveau
    options nouveau modeset=0
  '';
}
