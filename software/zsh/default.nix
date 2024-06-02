{...}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      "screenshare" = "wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "areashare" = "wf-recorder -g \"$(slurp)\" --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "ls" = "eza";
    };
    histSize = 10000;
    histFile = "$HOME/.config/zsh/.zsh_history";
    setOptions = [
      "AUTO_CD"
      "CHASE_DOTS"
      "HIST_IGNORE_DUPS"
      "INC_APPEND_HISTORY"
      "HIST_FCNTL_LOCK"
      "HIST_FIND_NO_DUPS"
      "EXTENDED_HISTORY"
    ];
    enableCompletion = true;
  };
}
