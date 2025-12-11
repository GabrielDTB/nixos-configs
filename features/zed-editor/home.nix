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
      rounded_selection = false;
      current_line_highlight = "none";
      hide_mouse = "never";
      cursor_blink = false;
      show_edit_predictions = false;
      buffer_line_height = "standard";
      agent = {
        use_modifier_to_send = true;
      };
      relative_line_numbers = "enabled";
    };
  };
}

