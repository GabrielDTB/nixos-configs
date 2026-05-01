{...}: {
  programs.zellij = {
    enable = true;
    settings = {
      copy_on_select = false;
      show_startup_tips = false;
      show_release_notes = false;
    };
    extraConfig = ''
      pane_frames false
    '';
    layouts = {
      default = ''
        layout {
          pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
          }
          pane
        }
      '';
    };
  };
}
