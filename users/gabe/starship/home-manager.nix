{lib, ...}: let
  enabled = [
    # Device (constant)
    "$hostname"
    # Dev Shell
    "$guix_shell"
    "$nix_shell"
    # Build / package management
    "$bun"
    "$cmake"
    "$conda"
    "$deno"
    "$dotnet"
    "$gradle"
    "$meson"
    "$nodejs"
    # Languages
    "$c"
    "$cobol"
    "$crystal"
    "$daml"
    "$dart"
    "$elixir"
    "$elm"
    "$erlang"
    "$fennel"
    "$gleam"
    "$golang"
    "$haskell"
    "$haxe"
    "$java"
    "$julia"
    "$kotlin"
    "$lua"
    "$mojo"
    "$nim"
    "$ocaml"
    "$odin"
    "$perl"
    "$php"
    "$purescript"
    "$python"
    "$rlang"
    "$raku"
    "$red"
    "$ruby"
    "$rust"
    "$scala"
    "$solidity"
    "$swift"
    "$typst"
    "$vlang"
    "$zig"
    ##
    "$package"
    # Source control
    "$fossil_branch"
    "$fossil_metrics"
    "$git_branch"
    "$git_state"
    "$git_status"
    "$git_metrics"
    "$hg_branch"
    "$pijul_channel"
    ##
    "$jobs"
    # Device (changing)
    "$memory_usage"
    "$battery"
    # Other
    "$cmd_duration"
    "$line_break"
    "$directory"
    "$line_break"
    "$character"
  ];
  disabled = [
    # Cloud
    "$aws"
    "$azure"
    "$gcloud"
    "$opa"
    "$openstack"
    "$pulumi"
    "$terraform"
    # Virtual/containerization
    "$container"
    "$docker_context"
    "$helm"
    "$kubernetes"
    "$singularity"
    "$vagrant"
    # Source Control
    "$git_commit"
    # Other
    "$buf"
    "$direnv"
    "$env_var"
    "$fill"
    "$localip"
    "$nats"
    "$quarto"
    "$os"
    "$shell"
    "$shlvl"
    "$spack"
    "$status"
    "$sudo"
    "$time"
    "$username"
    "$vcsh"
    "$custom"
  ];
in {
  imports = [
    ./nerd-font-symbols.nix
    ./compact-sections.nix
  ];
  programs.starship = {
    enable = true;
    enableFishIntegration = false;
    # enableTransience = true;
    settings =
      # Ensure modules get disabled
      lib.listToAttrs (map (name: {
          name = lib.substring 1 (-1) name;
          value = {disabled = true;};
        })
        disabled)
      # Ensure modules get enabled
      // lib.listToAttrs (map (name: {
          name = lib.substring 1 (-1) name;
          value = {disabled = false;};
        })
        enabled)
      // {
        add_newline = true;
        format = lib.concatStrings enabled;
        directory = {
          truncation_length = 0;
          truncate_to_repo = false;
          style = "cyan";
          before_repo_root_style = "cyan";
          repo_root_style = "bold cyan";
          disabled = false;
        };
        git_status = {
          conflicted = "$count";
          ahead = "$count";
          behind = "$count";
          diverged = "$ahead_count$behind_count";
          untracked = "$count";
          stashed = "󰘓$count";
          modified = "$count";
          staged = "$count";
          renamed = "󰗧$count";
          deleted = "󰧧$count";
          disabled = false;
        };
      };
  };
}
