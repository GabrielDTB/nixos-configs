{
  pkgs,
  config,
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
    /fish
    /fonts
    /ghostty
    /gimp
    /git
    /headscale
    /helix
    /hledger
    /jellyfin
    /lazygit
    /libreoffice
    /mpv
    /nix-index
    /nixos-aliases
    /osu
    /paperless
    /scanning
    /scripts
    /shattered-pixel-dungeon
    /signal
    /ssh-from
    /ssh-from/gtop
    /starship
    /steam
    /stylix
    /syncthing
    /thunar
    /tmux
    /virtualization
    /zathura
    /zen-browser
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
      ./tailscale.nix
      ./bees.nix
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

  nix.settings = {
    trusted-users = ["gabe"];
    secret-key-files = /home/gabe/.ssh/cache-priv-key.pem;
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  boot.supportedFilesystems = ["ntfs"];
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["pcie_acs_override=downstream,multifunction"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      # rocm-opencl-icd
      rocmPackages.clr.icd
    ];
  };

  # boot.extraModprobeConfig = ''
  #   blacklist nouveau
  #   options nouveau modeset=0
  # '';
  # boot.extraModulePackages = [pkgs.linuxPackages.nvidia_x11];
  # boot.blacklistedKernelModules = ["nouveau" "nvidia_drm" "nvidia_modeset" "nvidia"];
  hardware.nvidia = {
    modesetting.enable = false;
    powerManagement.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # packages = [ pkgs. ];

  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  environment.systemPackages = with pkgs; [
    lmstudio
    qbittorrent
    p7zip
    prismlauncher
    clinfo
    linuxPackages.nvidia_x11
    (let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSEnv (base
        // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
          profile = "export FHS=1";
          runScript = "fish";
          extraOutputsToInstall = ["dev"];
        }))
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "23.05";
}
