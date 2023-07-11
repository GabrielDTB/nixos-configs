
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

  #nixpkgs.config = {
  #  packageOverrides = pkgs: {
  #    unstable = import unstableTarball {
  #      config = config.nixpkgs.config;
  #    };
  #  };
  #};

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gbox";
  time.timeZone = "America/Los_Angeles";
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.dbus.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  hardware.opentabletdriver.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

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

  # Set initial kernel module settings
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  system.stateVersion = "23.05"; # Don't change. Just affects defaults.
}

