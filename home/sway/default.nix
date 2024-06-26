{
  pkgs,
  config,
  ...
}:
with config.theming; {
  home.packages = with pkgs; [
    tofi
    grim
    slurp
    wl-clipboard
    acpilight
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
  };

  #programs.tofi.enable = true;
  xdg.configFile."sway/tofi.ini".text = builtins.readFile ./tofi.ini;
  home.file.".config/sway/lockman.sh".text = builtins.readFile ./lockman.sh;

  wayland.windowManager.sway = let
    bg = color.background;
    hl = color.highlight;
    tx = color.text;
    ar = color.error;
    mod = "Mod4";
  in {
    enable = true;
    config = let
      mod = "Mod4";
    in rec {
      modifier = mod;
      terminal = "kitty -1";
      menu = "dmenu_path | tofi-run -c ~/.config/sway/tofi.ini | xargs swaymsg exec MOZ_ENABLE_WAYLAND=1  --";

      keybindings = {
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+c" = "kill";
        "${mod}+d" = "exec ${menu}";

        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+a" = "focus parent";

        "${mod}+s" = "layout stacking";
        "${mod}+w" = "laout tabbed";
        "${mod}+e" = "layout toggle split";

        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";
        "${mod}+0" = "workspace 10";

        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+Shift+BackSpace" = "move scratchpad";
        "${mod}+BackSpace" = "scratchpad show";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m '' -b 'Exit' 'swaymsg exit' --background ${bg} --button-text ${tx} --border ${bg} --button-background ${bg} --border-bottom ${ar}";

        "${mod}+r" = "mode resize";

        "${mod}+p" = "exec grim -t png - | wl-copy -t image/png";
        "${mod}+Shift+p" = "exec grim -g \"$(slurp)\" -t png - | wl-copy -t image/png";
        "${mod}+Control+p" = "exec grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') -t png - | wl-copy -t image/png";

        #"${mod}+equal" = "";
        #"${mod}+minus" = "";
        "${mod}+Shift+equal" = "exec xbacklight -inc 33.33 -steps 2";
        "${mod}+Shift+minus" = "exec xbacklight -dec 33.33 -steps 2";
      };

      bars = [];
      #bars = [{
      #  id = "0";
      #  position = "top";
      #  mode = "hide";
      #  statusCommand = "while ./status.sh; do sleep 1; done";
      #  colors = {
      #    statusline = tx;
      #    background = bg;
      #    focusedWorkspace = {
      #      background = hl;
      #      border = bg;
      #      text = bg;
      #    };
      #    inactiveWorkspace = {
      #      background = bg;
      #      border = bg;
      #      text = tx;
      #    };
      #    urgentWorkspace = {
      #      background = bg;
      #      border = bg;
      #      text = ar;
      #    };
      #  };
      #}];

      colors = {
        focused = {
          background = hl;
          border = hl;
          childBorder = hl;
          indicator = hl;
          text = hl;
        };
        focusedInactive = {
          background = bg;
          border = bg;
          childBorder = bg;
          indicator = bg;
          text = bg;
        };
      };

      gaps = {inner = 4;};

      window = {
        commands = [
          {
            command = "floating enable";
            criteria = {app_id = "pavucontrol";};
          }
          {
            command = "opacity 0.95";
            criteria = {class = ".*";};
          }
          {
            command = "opacity 0.95";
            criteria = {app_id = ".*";};
          }
        ];
      };

      focus = {followMouse = "always";};
    };
    # output DP-2 pos 0 0 res 1600x900@60Hz
    extraConfig = ''
      workspace 1 output DP-1
      workspace 2 output DP-1
      workspace 3 output DP-1
      workspace 4 output DP-1
      workspace 5 output DP-1
      workspace 6 output DP-1
      workspace 7 output DP-2
      workspace 8 output DP-2
      workspace 9 output DP-2
      workspace 10 output DP-2

      output DP-1 pos 0 0 res 2560x1440@165Hz
      bar {
        id 0
        position top
        mode hide

        status_command while echo "Up $(function displaytime { local T=$1; local D=$((T/60/60/24)); local H=$((T/60/60%24)); local M=$((T/60%60)); local S=$((T%60)); (( $D > 0 && $D != 1 )) && printf '%d days ' $D; (( $D > 0 && $D == 1 )) && printf '%d day ' $D; (( $H > 0 && $H != 1 )) && printf '%d hours ' $H; (( $H > 0 && $H == 1 )) && printf '%d hour ' $H; (( $M > 0 && $M != 1 )) && printf '%d minutes ' $M; (( $M > 0 && $M == 1 )) && printf '%d minute ' $M; (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '; (( $S != 1 )) && printf '%d seconds' $S; (( $S == 1 )) && printf '%d second' $S; }; displaytime $(cat /proc/uptime | cut -d '.' -f1)) '|' Kernel $(uname -r) '|' $(date '+%A %B %-d %-I:%M:%S %p %Z %Y')"; do sleep 1; done

        colors {
          statusline #${tx}
          background #${bg}
         focused_workspace #${bg} #${hl} #${bg}
          inactive_workspace #${bg} #${bg} #${tx}
          urgent_workspace #${bg} #${bg} #${ar}
        }
        font pango:monospace 12.0
      }
      font pango:monospace 0.01
      titlebar_border_thickness 0
      titlebar_padding 0

      ### Idle configuration
      exec sway-audio-idle-inhibit
      exec swayidle -w \
        timeout 300 'swaylock -f -c 000000' \
        timeout 270 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f -c 000000'
      set $lockman exec bash ~/.config/sway/lockman.sh
      bindsym ${mod}+l exec $lockman
    '';
  };

  programs.swaylock = {enable = true;};

  #programs.
}
