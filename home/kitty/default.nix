
{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    theme = "One Half Dark";
    #font = pkgs.nerdfonts;
    settings = {
      font_family = "IosevkaTerm NFM";
      confirm_os_window_close = 2;
    };
  };
}
