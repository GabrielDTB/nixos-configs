{...}: let
  features = map (x: ../../users/gabe + x) [
    /.
    /basic-utils
    /btop
    /core-replacements
    /cosmic
    /croc
    /direnv
    /firefox
    /gimp
    /git
    /helix
    /lazygit
    /libreoffice
    /mpv
    /nixos-aliases
    /prism-launcher
    /signal
    /steam
    /stylix
    /syncthing
    /tmux
    /zathura
    /zsh
  ];
in {
  imports =
    [
      ./disks.nix
      ./hardware-configuration.nix
      ./swap.nix
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
    extraHosts = ''
      108.35.129.44 gbox
    '';
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
