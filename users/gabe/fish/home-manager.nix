{
  pkgs,
  config,
  ...
}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellInit = ''
      starship init fish | source
    '';
    preferAbbrs = true;
    shellAbbrs = config.home.shellAliases;
    plugins = with pkgs.fishPlugins; [
      # {
      #   name = "tide";
      #   inherit (tide) src;
      # }
      {
        name = "async-prompt";
        inherit (async-prompt) src;
      }
      {
        name = "transient-fish";
        inherit (transient-fish) src;
      }
    ];
  };
}
