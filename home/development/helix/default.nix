{pkgs, ...}: {
  home.packages = with pkgs; [
    lldb # For debugging
    rust-analyzer # Rust LSP
    nil # Nix LSP
    nixfmt # Nix formatter
    # taplo # TOML LSP
  ];
  # xdg.configFile."helix/languages.toml".text = ''
  #   [[language]]
  #   name = "rust"
  #   formatter = { command = "cargo fmt", args = [] }
  # '';

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor = {
        indent-guides.render = true;
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        line-number = "relative";
      };
    };
  };
}
