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
    ./kmonad.nix
    inputs.disko.nixosModules.disko
    ((import ../../features/utils.nix).getFeatures [
      /adb
      /basic-utils
      /btop
      # /colmap-gbox
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
      /kmonad
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
      /zed-editor
      /zellij
      /zen-browser
    ])
  ];

  # systemd.timers.NVFanControl = {
  #   wantedBy = [ "timers.target" ];
  #    timerConfig = {
  #       OnBootSec = "1s";
  #       OnUnitActiveSec = "1s";
  #     };
  # };

  # systemd.services.NVFanControl = {
  #     enable = true;
  #     description = "NVIDIA Fan Control Bash Script";
  #     serviceConfig = { Type = "oneshot";  };
  #     path = [pkgs.gawk]; #used for sine wave curve calc
  #     wantedBy = [ "default.target" ];
  #     partOf = ["default.target" ];
  #     script = ''
  #     declare -i gpuTemp
  #     declare -i gpuTempFloor
  #     declare -i gpuTempCeiling
  #     declare -i targetFanSpeed
  #     declare -i fallbackFanSpeed

  #     gpuTemp=$(/run/current-system/sw/bin/nvidia-settings -q gpucoretemp -c 0 2> /dev/null | grep -Po "(?<=: )[0-9]+(?=\.)")
  #     gpuTempFloor=$((gpuTemp<50 ? 50 : gpuTemp)) #minimum bound of fan curve
  #     gpuTempCeiling=$((gpuTempFloor>80 ? 80 : gpuTempFloor)) #maximum bound of fan curve
  #     targetFanSpeed=$(gawk -v temp=$gpuTempCeiling 'BEGIN{printf "%.0f", 35 * sin((temp-1.5)/10)+65}') #calculate the target fan speed based on a sine curve from x=50 to x=80. round to the nearest whole number.
  #     finalFanSpeed=$((targetFanSpeed>=30 && targetFanSpeed<=100 ? targetFanSpeed : 100)) #if a valid fan target wasn't calculated, turn fans on 100% as a safety measure

  #     echo "Current Temp: $gpuTemp | Target Fan Speed: $finalFanSpeed"
  #     /run/current-system/sw/bin/nvidia-settings -a GPUTargetFanSpeed="$finalFanSpeed" -c 0
  #     '';
  # };
  programs.coolercontrol = {
    enable = true;
  };

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
