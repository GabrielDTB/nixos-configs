{pkgs, ...}: let
  features = map (x: ../../users/gabe + x) [
    /.
    /adb
    /basic-utils
    /btop
    /core-replacements
    /cosmic
    /croc
    /direnv
    /firefox
    /fish
    /ghostty
    /gimp
    /git
    /helix
    /lazygit
    /libreoffice
    /mpv
    /nix-index
    /nixos-aliases
    /prism-launcher
    /signal
    /starship
    /steam
    /stylix
    /syncthing
    /tmux
    /zathura
  ];
in {
  imports =
    [
      ./disks.nix
      ./hardware-configuration.nix
      ./swap.nix
      ./tailscale.nix
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

  networking = {
    hostName = "gtop";
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

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
