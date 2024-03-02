{ config, ...}: 
with config.theming;
{
  programs.kitty = {
    enable = true;
    # Base theme.
    theme = "One Half Dark";
    settings = {
      font_family = font.monospaced;
      confirm_os_window_close = 2;
      background = "#"+color.background;
      foreground = "#"+color.text;
    };
  };
}
