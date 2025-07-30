{
  inputs,
  pkgs,
  ...
}: let
  userUtils = import ../../users/utils.nix;
in {
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ./swap.nix
    ./tailscale.nix
    ./bees.nix
    inputs.disko.nixosModules.disko
    (userUtils.userWithFeatures "gabe" [
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

  programs.noisetorch.enable = true;

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
