{ home, config, lib, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];
  services.syncthing = {
    enable = true;
  };
  home.packages = with pkgs; [
    obsidian
  ];
}