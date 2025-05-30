{
  pkgs,
  inputs,
  ...
}: let
  features = map (x: ../../users/gabe + x) [
    /.
    /adb
    /aider
    /basic-utils
    /btop
    /core-replacements
    /cosmic
    /croc
    /direnv
    /easyeffects
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
    /scripts
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
  hardware.printers.ensurePrinters = [
    {
      name = "Gateway4";
      description = "HP Laserjet Pro M880";
      location = "Gateway South 4th Floor";
      deviceUri = "ipps://cspm880.cs.stevens.edu/ipp/print";
      model = "everywhere";
    }
  ];

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "gfrm";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Fast boot.
  boot = {
    loader = {
      # systemd-boot = {
      #   enable = true;
      #   editor = false;
      # };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        timeoutStyle = "hidden";
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
