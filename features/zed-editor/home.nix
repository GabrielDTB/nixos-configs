{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "lean4"
      "nix"
      "typst"

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
      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
      };
      tab_bar.show = false;
      tabs = {
        file_icons = true;
      };
      gutter = {
        folds = false;
        runnables = false;
        breakpoints = false;
        min_line_number_digits = 2;
      };
      project_panel = {
        indent_size = 12;
      };
      terminal = {
        max_scroll_history_lines = 100000;
      };
      outline_panel.button = false;
      debugger.button = false;
      notification_panel.button = false;
      search.button = false;
      scrollbar.show = "never";
    };
  };
}

