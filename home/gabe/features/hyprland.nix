{
  lib,
  pkgs,
  config,
  mkFeature,
  ...
}:
mkFeature {
  name = "hyprland";
  enableDefault = true;
  body = {
    home.packages = with pkgs; [
      killall
      brightnessctl
      wl-clipboard-rs
    ];

    features = {
      tofi.enable = true;
      thunar.enable = true;

      graphical-environment.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = let
        modifier = "SUPER_L";
        terminal = "kitty";
        menu = "tofi-run";
      in
        with lib; {
          monitor = flatten [
            "desc:BOE 0x095F, 2256x1504@60, auto, 1.175"
            "desc:PanaScope Pixio PX277P, 2560x1440@165, auto, 1"
            ", preferred, auto, 1" # catch-all
          ];

          bind = flatten [
            "${modifier}, RETURN, exec, ${terminal}"
            "${modifier}, D, exec, ${menu} | xargs hyprctl dispatch exec --"

            "${modifier}, C, killactive,"
            "${modifier} ALT, ESCAPE, exit,"
            "${modifier}, L, exec, hyprlock"

            "${modifier}, F, fullscreen,"
            "${modifier} SHIFT, SPACE, togglefloating,"

            "${modifier}, LEFT, movefocus, l"
            "${modifier}, RIGHT, movefocus, r"
            "${modifier}, UP, movefocus, u"
            "${modifier}, DOWN, movefocus, d"

            "${modifier}, S, togglespecialworkspace, magic"
            "${modifier} SHIFT, S, movetoworkspace, special:magic"

            "${modifier}, SPACE, exec, killall -SIGUSR1 .waybar-wrapped"

            ''${modifier}, P, exec, grim -t png - | wl-copy -t image/png''
            ''${modifier} SHIFT, P, exec, grim -g "$(slurp)" -t png - | wl-copy -t image/png''
            ''${modifier} CONTROL, P, exec, grim -o $(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name") -t png - | wl-copy -t image/png''

            (
              map (x: let
                ws = toString x;
                key = toString (mod x 10);
              in [
                "${modifier}, ${key}, workspace, ${ws}"
                "${modifier} SHIFT, ${key}, movetoworkspace, ${ws}"
              ]) (range 1 10)
            )

            "${modifier}, TAB, hyprexpo:expo, toggle"
          ];

          bindel = [
            ", XF86MonBrightnessUp, exec, brightnessctl set +3%"
            ", XF86MonBrightnessDown, exec, brightnessctl set 3%-"
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];

          # bindm = let
          #   mousebutton = index: "mouse:${toString (index + 271)}";
          # in [
          #   "${modifier}, ${mousebutton 1}, movewindow"
          #   "${modifier}, ${mousebutton 2}, resizewindow"
          # ];

          bindit = [", SUPER_L, exec, killall -SIGUSR1 .waybar-wrapped"];
          binditr = [", SUPER_L, exec, killall -SIGUSR1 .waybar-wrapped"];

          input = {
            follow_mouse = 2;
            float_switch_override_focus = 0;
            special_fallthrough = true;
          };

          "misc:middle_click_paste" = false;
          exec-once = [
            "waybar"
          ];
        };

      plugins = with pkgs.hyprlandPlugins; [
        hyprexpo
      ];
    };

    # programs.hyprlock = with lib.stylix.colors; {
    programs.hyprlock = with config.lib.stylix.colors; {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          ignore_empty_input = true;
        };
        background = {
          color = "rgb(${base00})";
        };
        input-field = {
          size = "952, 60";
          outline_thickness = 6;
          dots_size = 0.2;
          outer_color = "rgb(${base02})";
          inner_color = "rgb(${base01})";
          font_color = "rgb(${base05})";
          fade_timeout = 15 * 1000;
          placeholder_text = "Enter password.";
          rounding = 0;
          check_color = "rgb(${green})";
          fail_color = "rgb(${bright-red})";
          fail_text = "Wrong password.";
          capslock_color = "rgb(${red})";
          numlock_color = "rgb(${cyan})";
          bothlock_color = "rgb(${magenta})";
          position = "0, 6";
          halign = "center";
          valign = "bottom";
        };
        label = {
          text = "$TIME<br/><b>$ATTEMPTS[]</b>";
          text_align = "center";
          color = "rgb(${base05})";
          font_size = 64;
          position = "0, 0";
          halign = "center";
          valign = "center";
        };
      };
    };

    programs.waybar = {
      enable = true;
      style = ''
        window#waybar.* {
          font-size: 12pt;
          font-family: Fira Code Nerd Font;
        }

        #idle_inhibitor,
        #pulseaudio,
        #tray,
        #usage,
        #bat,
        #net {
          background-color: @base01;
          border-radius: 10px;
          padding-left: 0.5em;
          padding-right: 0.5em;
          margin-left: 0.3em;
        }

        #battery,
        #memory,
        #network {
          margin-right: 0.8em;
        }

        #bluetooth {
          padding-right: 0.3em;
        }
      '';
      settings = {
        mainBar = {
          mode = "hide";
          start_hidden = true;

          layer = "top";
          position = "top";
          height = 20;
          spacing = 5;

          modules-left = [
            "hyprland/workspaces"
            "group/usage"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "idle_inhibitor"
            "group/bat"
            "pulseaudio"
            "group/net"
            "tray"
          ];

          "group/usage" = {
            orientation = "horizontal";
            modules = [
              "memory"
              "cpu"
            ];
          };

          "group/bat" = {
            orientation = "horizontal";
            modules = [
              "battery"
              "backlight"
            ];
          };

          "group/net" = {
            orientation = "horizontal";
            modules = [
              "network"
              "bluetooth"
            ];
          };

          "hyprland/workspaces" = {
            all-outputs = true;
            disable-scroll = true;
          };

          idle_inhibitor = {
            format = "{icon} ";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          "clock" = {
            format = "{:%Y.%m.%d | %H:%M}";
            tooltip-format = ''<span><tt><small>{calendar}</small></tt></span>'';
          };

          battery = {
            interval = 10;
            # states = {
            #   warning = 30;
            #   critical = 15;
            # };
            format = "{icon} {capacity}%";
            format-charging = " {icon} {capacity}%";
            format-plugged = " {capacity}%";
            format-alt = "{icon} {time}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            tooltip = true;
          };

          cpu = {
            interval = 1;
            format = " {usage}%";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          memory = {
            interval = 1;
            format = " {used:0.1f}G ({}%)";
          };

          network = {
            interval = 5;
            format-wifi = "";
            format-ethernet = "";
            format-disconnected = "󰤮";
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
            tooltip-format-ethernet = "{ifname} {ipaddr}";
            tooltip-format-disconnected = "Disconnected";
          };

          bluetooth = {
            format = "󰂯";
            format-disabled = "󰂲";
            format-connected = "󰂰";
            tooltip-format = ''{controller_alias}\t{controller_address}'';
            tooltip-format-connected = ''{controller_alias}\t{controller_address}\n\n{device_enumerate}'';
            tooltip-format-enumerate-connected = ''{device_alias}\t{device_address}'';
            on-click = "blueman-manager";
          };

          backlight = {
            format = "{icon} {percent}%";
            format-icons = ["" "" "" "" "" "" "" "" ""];
            tooltip = false;
          };

          pulseaudio = {
            scroll-step = 2;
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{icon} {volume}% {format_source}";
            format-bluetooth-muted = "󰝟 {format_source}";
            format-muted = "󰝟 {format_source}";
            format-source = "{volume}%";
            format-source-muted = "";
            format-icons = {
              headphones = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };

          tray = {
            spacing = 10;
          };
        };
      };
    };
  };
}
