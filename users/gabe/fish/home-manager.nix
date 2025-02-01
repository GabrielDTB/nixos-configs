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
      snippet = ''
        if test (count $argv) -ne 2
          echo "Error: snippet requires exactly 2 arguments"
          echo "Usage: snippet SOURCE_PATH DESTINATION_PATH"
          return 1
        end

        set requested_snippet $argv[1]
        set source_path ${../../../snippets}/$requested_snippet
        set dest_path $argv[2]

        if not test -f $source_path
          echo "Error: Snippet '$requested_snippet' does not exist"
          return 1
        end

        if cp $source_path $dest_path && chmod u+wx $dest_path
          echo "Successfully copied '$requested_snippet' to '$dest_path'"
          return 0
        else
          echo "Error: Failed to copy snippet"
          return 1
        end
      '';
    };
  };
}
