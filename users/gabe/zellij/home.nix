{...}: {
  programs.zellij = {
    enable = true;
    settings = {
      copy_on_select = false;
      show_startup_tips = false;
      show_release_notes = false;
    };
  };
}
