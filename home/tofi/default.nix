{ inputs, outputs, lib, config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tofi
  ];
  programs.tofi.enable = true;
}
