
{ inputs, outputs, lib, config, pkgs, ... }:

#let
#  unstableTarball =
#    fetchTarball {
#      url = "https://github.com/NixOS/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz";
#      sha256 = "0fcqpsy6y7dgn0y0wgpa56gsg0b0p8avlpjrd79fp4mp9bl18nda";
#    };
#in
{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Disk layouts.
    ./disks.nix
    # System packages.
    ./system-packages.nix
    # Users.
    ./users.nix
    # Snapshots
    ./immich.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  services.foldingathome.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  users.users."gabe".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWwpJxQlIenoxGRuVSjI9soGmEWxe9Wnql4UcNg+g0" # content of authorized_keys file
    # note: ssh-copy-id will add user@your-machine after the public key
    # but we can remove the "@your-machine" part
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "pcie_acs_override=downstream,multifunction" ];

  #nixpkgs.config = {
  #  packageOverrides = pkgs: {
  #    unstable = import unstableTarball {
  #      config = config.nixpkgs.config;
  #    };
  #  };
  #};

  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # networking = {
  #   # extraHosts = ''
  #   # 192.168.122.198 immich.services.gabrieltb.me
  #   # '';
  #   firewall.extraCommands = ''
  #     iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 192.168.122.198:443
  #   '';
  # };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking = { 
    hostName = "gbox";
    extraHosts = ''
      192.168.1.216   immich
      192.168.1.171   kopia
    '';
  };
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
  services.jellyfin.enable = true;
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; [ mesa.drivers rocm-opencl-icd ];
  };
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
    # modesetting.enable = true;
    # powerManagement.enable = false;
    # powerManagement.finegrained = false;
    # open = false;
    # nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  
# services.udev.extraRules = ''
#   # Remove NVIDIA USB xHCI Host Controller devices, if present
#   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
#   # Remove NVIDIA USB Type-C UCSI devices, if present
#   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
#   # Remove NVIDIA Audio devices, if present
#   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
#   # Remove NVIDIA VGA/3D controller devices
#   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
# '';
# boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  hardware.opentabletdriver.enable = true;
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
  };
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  environment.systemPackages = with pkgs; [ virt-manager ];
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

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
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

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

  system.stateVersion = "23.05"; # Don't change. Just affects defaults.
}
