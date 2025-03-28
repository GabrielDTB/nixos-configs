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
    /zen-browser
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

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.printing.enable = true;

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    # docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];

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
