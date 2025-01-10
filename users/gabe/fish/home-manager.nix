{config, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    preferAbbrs = true;
    shellAbbrs = config.home.shellAliases;
  };
}
