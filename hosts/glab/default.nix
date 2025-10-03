{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ./swap.nix
    ./tailscale.nix
    ./bees.nix
    inputs.disko.nixosModules.disko
    ((import ../../features/utils.nix).getFeatures [
      /adb
      /basic-utils
      /btop
      # /colmap-gbox
      /colemak-dh-ortho
      /core-replacements
      /cosmic
      /croc
      /devenv
      /direnv
      /ffmpeg
      /fhs
      /fish
      /fonts
      /ghostty
      /gimp
      /git
      /helix
      /lazygit
      /libreoffice
      /meshlab
      /mpv
      /music
      /nix-index
      /nixos-aliases
      /obsidian
      /podman
      /qimgv
      /scripts
      /ssh-from
      /ssh-from/gbox
      /ssh-from/gfrm
      /starship
      /stylix
      /syncthing
      /thunar
      /tmux
      /virtualization
      /xpra
      /zathura
      /zellij
      /zen-browser
    ])
  ];

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

  networking.hostName = "glab";

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  boot.supportedFilesystems = ["ntfs"];

  boot.kernelParams = ["pcie_acs_override=downstream,multifunction"];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = true;
      package = pkgs.linuxPackages.nvidiaPackages.stable;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
  nixpkgs.config.cudaSupport = true;

  environment.systemPackages = with pkgs; [
    p7zip
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "25.05";
}
