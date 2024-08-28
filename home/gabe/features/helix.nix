{
  pkgs,
  mkFeature,
  ...
}:
mkFeature {
  name = "helix";
  enableDefault = true;
  body = {
    home.packages = with pkgs; [
      lldb # For debugging
      rust-analyzer # Rust LSP
      nil # Nix LSP
      python312Packages.python-lsp-server # python lsp -- version shouldn't matter much
      black # python formatter
    ];

    programs.helix = {
      enable = true;
      settings = {
        editor = {
          middle-click-paste = false;
          scroll-lines = 1;
          line-number = "relative";
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
          auto-completion = false;
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
