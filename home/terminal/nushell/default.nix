{...}: {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    shellAliases = {
      "screenshare" = "wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "areashare" = "wf-recorder -g \"$(slurp)\" --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
    };
  };
}
