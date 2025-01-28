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
      {
        name = "async-prompt";
        inherit (async-prompt) src;
      }
      {
        name = "transient-fish";
        inherit (transient-fish) src;
      }
    ];
    functions = {
      transient_prompt_func = ''
        set --local color green
        if test $transient_pipestatus[-1] -ne 0
          set color red
        end
        echo -en (set_color brblack)(date "+%H:%M:%S")(set_color $color)" ❯ "(set_color normal)
      '';
    };
  };
}
