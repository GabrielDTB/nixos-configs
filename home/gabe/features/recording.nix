{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "recording";
  body = {
    home.packages = with pkgs; [
      wf-recorder
      slurp
      grim
      wl-clipboard-rs
    ];

    home.shellAliases = {
      screenshare = "wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      areashare = "wf-recorder -g \"$(slurp)\" --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "screenshot" = "exec grim -t png - | wl-copy -t image/png";
      "screenshot-area" = "exec grim -g \"$(slurp)\" -t png - | wl-copy -t image/png";
      "screenshot-monitor" = "exec grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') -t png - | wl-copy -t image/png";
    };
  };
}
