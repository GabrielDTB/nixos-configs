{pkgs, inputs, ...}: let
  features = map (x: ../../users/gabe + x) [
    /.
    /adb
    /basic-utils
    /btop
    /core-replacements
    /cosmic
    /croc
    /direnv
    /fish
    /fonts
    /ghostty
    /gimp
    /git
    # /gnome
    /helix
    /lazygit
    /libreoffice
    /mpv
    /nix-index
    /nixos-aliases
    /osu
    /prism-launcher
    /signal
    /starship
    /steam
    /stylix
    /syncthing
    /tmux
    /zathura
    /zen-browser
  ];
in {
  imports =
    [
      ./disko-config.nix
      ./hardware-configuration.nix
      ./tailscale.nix
      inputs.disko.nixosModules.disko
    ]
    ++ (map (x: (import x).nixos or {}) features);

  home-manager.users = {
    gabe = {
      imports = map (x: (import x).home-manager or {}) features;
      home = {
        username = "gabe";
        homeDirectory = "/home/gabe";
      };
    };
  };

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "gfrm";
  };

  # Fast boot.
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

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
