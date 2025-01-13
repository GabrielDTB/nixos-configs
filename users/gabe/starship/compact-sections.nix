{...}: {
  programs.starship = {
    settings = {
      aws = {
        format = "([$symbol$profile(:$region)(:$duration)]($style) )";
      };
      bun = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      c = {
        version_format = "$raw";
        format = "([$symbol$version(-$name)]($style) )";
      };
      cmake = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      cmd_duration = {
        format = "([($duration)]($style) )";
      };
      cobol = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      conda = {
        version_format = "$raw";
        format = "([$symbol$environment]($style) )";
      };
      crystal = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      daml = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      dart = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      deno = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      docker_context = {
        format = "([$symbol$context]($style) )";
      };
      dotnet = {
        version_format = "$raw";
        format = "([$symbol$version($tfm)]($style) )";
      };
      elixir = {
        version_format = "$raw";
        format = "([$symbol$version(OTP$otp_version)]($style) )";
      };
      elm = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      erlang = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      fennel = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      fossil_branch = {
        format = "([$symbol$branch]($style) )";
      };
      gcloud = {
        format = "([$symbol$account(@$domain:$region)]($style) )";
      };
      git_branch = {
        format = "([$symbol$branch]($style) )";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
      };
      git_metrics = {
        format = "([($added)]($added_style)[($deleted)]($deleted_style) )";
      };
      golang = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      gradle = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      guix_shell = {
        format = "([$symbol]($style) )";
      };
      haskell = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      haxe = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      helm = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      hg_branch = {
        format = "([$symbol$branch]($style) )";
      };
      java = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      julia = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      kotlin = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      kubernetes = {
        format = "([$symbol$context(:$namespace)]($style) )";
      };
      lua = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      memory_usage = {
        format = "([$symbol$ram(:$swap)]($style) )";
      };
      meson = {
        version_format = "$raw";
        format = "([$symbol$project]($style) )";
      };
      nim = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      nix_shell = {
        format = "([$symbol$state:$name]($style) )";
      };
      nodejs = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      ocaml = {
        version_format = "$raw";
        format = "([$symbol$version$switch_indicator$switch_name]($style) )";
      };
      opa = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      openstack = {
        format = "([$symbol$cloud$project]($style) )";
      };
      os = {
        format = "([$symbol]($style) )";
      };
      package = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      perl = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      php = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      pijul_channel = {
        version_format = "$raw";
        format = "([$symbol$channel]($style) )";
      };
      pulumi = {
        version_format = "$raw";
        format = "([$symbol$stack]($style) )";
      };
      purescript = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      python = {
        version_format = "$raw";
        format = "([$symbol$pyenv_prefix$version$virtualenv]($style) )";
      };
      raku = {
        version_format = "$raw";
        format = "([$symbol$version(:$vm_version)]($style) )";
      };
      red = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      ruby = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      rust = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      scala = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      spack = {
        version_format = "$raw";
        format = "([$symbol$environment]($style) )";
      };
      sudo = {
        format = "([$symbol]($style) )";
      };
      swift = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      terraform = {
        version_format = "$raw";
        format = "([$symbol$workspace]($style) )";
      };
      time = {
        format = "([$time]($style) )";
      };
      typst = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      username = {
        format = "([$user]($style) )";
      };
      vagrant = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      vlang = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      zig = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
      solidity = {
        version_format = "$raw";
        format = "([$symbol$version]($style) )";
      };
    };
  };
}
