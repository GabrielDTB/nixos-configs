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
    /lazygit
    /libreoffice
    /mpv
    /nixos-aliases
    /signal
    /steam
    /stylix
    /syncthing
    /tmux
    /zsh
  ];
in {
  imports =
    [
      ./hardware-configuration.nix
      ./disks.nix

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

  networking = {
    hostName = "gtop";
    networkmanager.enable = true;
    extraHosts = ''
      108.35.129.44 gbox
    '';
  };

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

  environment.systemPackages = with pkgs; [
    zathura
  ];

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
