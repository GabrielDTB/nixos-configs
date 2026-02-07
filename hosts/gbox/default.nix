{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./disks.nix
    # ./elden-ring-backup.nix
    ./disable-ds4-touchpad.nix
    ./hardware-configuration.nix
    ./immich
    # ./kopia.nix
    ./swap.nix
    ./tailscale.nix
    ./bees.nix
    ./kmonad.nix
    ./snapshotting.nix
    ((import ../../features/utils.nix).getFeatures [
      /adb
      # /aider
      /appimage
      /basic-utils
      # /beets
      /btop
      /calibre
      # /colmap-gbox
      /colemak-dh-ortho
      /core-replacements
      /cosmic
      /croc
      /cryptsetup
      /devenv
      /direnv
      /ffmpeg
      /fhs
      /fish
      /flatpak
      /fonts
      /ghostty
      /gimp
      /git
      /gonic
      /headscale
      /helix
      /hledger
      # /jellyfin
      /kmonad
      /kopia
      /lazygit
      /libreoffice
      /meshlab
      /miniflux
      /mpv
      /music
      # /music-making
      /nix-index
      /nixos-aliases
      /obsidian
      # /ollama
      /open-webui
      /osu
      # /paperless
      /podman
      /qbittorrent
      /qimgv
      /scanning
      /scripts
      /shattered-pixel-dungeon
      /signal
      /snapshotting
      /ssh-from
      /ssh-from/gfrm
      /starship
      /steam
      /stylix
      /syncthing
      # /thelounge
      /thunar
      # /tmux
      /virtualization
      /xpra
      /zathura
      /zed-editor
      /zellij
      /zen-browser
    ])
  ];

  # nixpkgs.config.cuda-support = true;
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

  networking.extraHosts = ''
    127.0.0.1 youtube.com
    127.0.0.1 www.youtube.com
  '';

  # boot.extraModprobeConfig = ''
  #   blacklist nouveau
  #   options nouveau modeset=0
  # '';
  # boot.extraModulePackages = [pkgs.linuxPackages.nvidia_x11];
  # boot.blacklistedKernelModules = ["nouveau" "nvidia_drm" "nvidia_modeset" "nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = false;
  #   powerManagement.enable = true;
  #   open = false;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };
  # packages = [ pkgs. ];

  boot.initrd.kernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  environment.systemPackages = with pkgs; [
    lmstudio
    p7zip
    prismlauncher
    clinfo
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  system.stateVersion = "23.05";
}
