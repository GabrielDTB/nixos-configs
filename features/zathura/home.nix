{...}: {
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      incremental-search = true;
      selection-notification = false;
    };
  };
}
