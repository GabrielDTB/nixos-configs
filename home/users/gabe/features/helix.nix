{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.helix;
in {
  options.features.helix = {
    enable = lib.mkEnableOption "Helix" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lldb # For debugging
      rust-analyzer # Rust LSP
      nil # Nix LSP
      # nixfmt # Nix formatter
      # taplo # TOML LSP
    ];

    programs.helix = {
      enable = true;
      settings = {
        # theme = "onedark";
        editor = {
          middle-click-paste = false;
          scroll-lines = 1;
          line-number = "relative";
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
          auto-completion = false;
          # preview-completion-insert = false;
          completion-replace = true;
          rulers = [101];
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            render = true;
            character = "│";
            skip-levels = 1;
          };
        };
        keys = {
          normal = {
            space.h = ":toggle lsp.display-inlay-hints";
            C-a = "code_action";
          };
          insert = {
          };
          select = {
          };
        };
      };
    };
  };
}
