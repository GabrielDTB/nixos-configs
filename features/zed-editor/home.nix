{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "lean4"
      "nix"

      "git-firefly"
      "toml"
    ];
    userSettings = {
      helix_mode = true;
      auto_update = false;
      git = {
        inline_blame.enabled = false;
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}

