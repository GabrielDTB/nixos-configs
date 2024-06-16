{inputs, pkgs, lib, config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./immich.nix
    ./immich-container.nix
    ./software
    
    ../common/global
    ../common/users/gabe
    ../common/users/tamy

    ../common/optional/developing.nix
    ../common/optional/virtualization.nix
    ../common/optional/ssh.nix
    ../common/optional/core-replacements.nix
    ../common/optional/graphical-environment-full.nix
    ../common/optional/zsh.nix
    ../common/optional/bluetooth.nix
  ];

  boot.supportedFilesystems = ["ntfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["pcie_acs_override=downstream,multifunction"];

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=360
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [mesa.drivers rocm-opencl-icd];
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  programs.adb.enable = true;

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
}
