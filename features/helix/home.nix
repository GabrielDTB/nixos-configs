{pkgs, ...}: {
  home.packages = with pkgs; [
    nil
  ];

  # xdg.desktopEntries.helix = {
  #   name = "helix";
  #   exec = "hx";
  #   terminal = true;
  #   type = "Application";
  #   categories = ["TextTools" "TextEditor" "ConsoleOnly" "Development"];
  #   mimeType = ["text/plain"];
  # };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        middle-click-paste = false;
        scroll-lines = 1;
        line-number = "relative";
        gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
        auto-completion = false;
        completion-replace = true;
        rulers = [81];
        lsp = {
          auto-signature-help = false;
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
        soft-wrap = {
          enable = true;
          wrap-indicator = "";
        };
      };
      keys = {
        normal = {
          space.h = ":toggle lsp.display-inlay-hints";
          S-c = "toggle_block_comments";
          C-a = "code_action";
        };
        insert = {
          C-h = "signature_help";
        };
        select = {
          S-c = "toggle_block_comments";
        };
      };
    };
  };
}
