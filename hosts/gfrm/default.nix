{inputs, ...}: {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ./tailscale.nix
    ./bees.nix
    ./kmonad.nix
    inputs.disko.nixosModules.disko
    ((import ../../features/utils.nix).getFeatures "gfrm" [
      # /.
      /adb
      /appimage
      /basic-utils
      /btop
      /colemak-dh-ortho
      /core-replacements
      /cosmic
      /croc
      /devenv
      /direnv
      /easyeffects
      /ffmpeg
      /fhs
      /fish
      /fonts
      /ghostty
      /gimp
      /git
      # /gnome
      /helix
      /kmonad
      /kopia
      /lazygit
      /libreoffice
      /meshlab
      /mpv
      /nix-index
      /nixos-aliases
      /obsidian
      /osu
      /prism-launcher
      /qimgv
      /scripts
      /signal
      /snapshotting
      /starship
      /steam
      /stylix
      /syncthing
      /thunar
      /tmux
      /xpra
      /zathura
      /zellij
      /zed-editor
      /zen-browser
    ])
  ];

  services.fwupd.enable = true;
  services.fprintd.enable = true;

  services.printing.enable = true;
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

  # time.timeZone = "America/Los_Angeles";
  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
