{
  pkgs,
  config,
  mkFeature,
  ...
}:
mkFeature {
  name = "graphical-environment";
  body = {
    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      # Screen recording / screenshotting.
      wl-screenrec
      wf-recorder
      ffmpeg-full
      v4l-utils
      slurp
      grim
    ];
    boot = {
      kernelModules = [
        "v4l2loopback"
        "snd-aloop"
      ];
      extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
      extraModprobeConfig = ''
        # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
        # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
        # https://github.com/umlaeute/v4l2loopback
        options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      '';
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services = {
      dbus.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };

    xdg.portal = {
      enable = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -ro";
          };
        };
      };
      config.common.default = "*";
    };

    security.pam.services.swaylock = {};
  };
}
