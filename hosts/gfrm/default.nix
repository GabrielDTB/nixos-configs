{inputs, ...}: let
  userUtils = import ../../users/utils.nix;
in {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ./tailscale.nix
    ./bees.nix
    inputs.disko.nixosModules.disko
    (userUtils.userWithFeatures "gabe" [
      # /.
      /adb
      /aider
      /basic-utils
      /btop
      /colmap
      /core-replacements
      /cosmic
      /croc
      /direnv
      /easyeffects
      /ffmpeg
      /fish
      /fonts
      /ghostty
      /gimp
      /git
      # /gnome
      /helix
      /lazygit
      /libreoffice
      /meshlab
      /mpv
      /nix-index
      /nixos-aliases
      /osu
      /prism-launcher
      /qimgv
      /scripts
      /signal
      /starship
      /steam
      /stylix
      /syncthing
      /thunar
      /tmux
      /xpra
      /zathura
      /zen-browser
    ])
  ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  # services.printing.enable = true;
  # hardware.printers.ensurePrinters = [
  #   {
  #     name = "Gateway4";
  #     description = "HP Laserjet Pro M880";
  #     location = "Gateway South 4th Floor";
  #     deviceUri = "ipps://cspm880.cs.stevens.edu/ipp/print";
  #     model = "everywhere";
  #   }
  # ];

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
