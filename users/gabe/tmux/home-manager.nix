{...}: {
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
