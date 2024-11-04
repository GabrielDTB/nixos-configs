{pkgs, ...}: let
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
    /hledger
    /lazygit
    /libreoffice
    /mpv
    /nixos-aliases
    /osu
    /shattered-pixel-dungeon
    /signal
    /ssh-from
    /ssh-from/gtop
    /steam
    /stylix
    /syncthing
    /tmux
    /virtualization
    /zathura
    /zsh
  ];
in {
  imports =
    [
      ./disks.nix
      ./elden-ring-backup.nix
      ./disable-ds4-touchpad.nix
      ./hardware-configuration.nix
      ./immich
      ./kopia.nix
      ./swap.nix
    ]
    ++ (map (x: (import x).nixos or {}) features);

  home-manager.users.gabe = {
    imports = map (x: (import x).home-manager or {}) features;
    home = {
      username = "gabe";
      homeDirectory = "/home/gabe";
    };
  };

  programs.noisetorch.enable = true;

  networking.hostName = "gbox";

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["pcie_acs_override=downstream,multifunction"];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      mesa.drivers
      rocm-opencl-icd
      rocmPackages.clr.icd
    ];
  };

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';

  environment.systemPackages = with pkgs; [
    qbittorrent
    p7zip
    prismlauncher
    xboxdrv
    clinfo
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "23.05";
}
