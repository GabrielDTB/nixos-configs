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
    features = {
      tofi.enable = true;
      thunar.enable = true;

      graphical-environment.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        # "$fileManager" = "thunar";
        "$menu" = "tofi-run";

        bind = lib.flatten [
          "$mod, RETURN, exec, $terminal"
          "$mod, D, exec, $menu | xargs hyprctl dispatch exec --"

          "$mod, C, killactive,"
          "$mod ALT, ESCAPE, exit,"
          "$mod, L, exec, hyprlock"

          "$mod, F, fullscreen,"
          "$mod SHIFT, SPACE, togglefloating,"

          "$mod, LEFT, movefocus, l"
          "$mod, RIGHT, movefocus, r"
          "$mod, UP, movefocus, u"
          "$mod, DOWN, movefocus, d"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          (with lib;
            map (x: let
              ws = toString x;
              key = toString (mod x 10);
            in [
              "$mod, ${key}, workspace, ${ws}"
              "$mod SHIFT, ${key}, movetoworkspace, ${ws}"
            ]) (range 1 10))

          "$mod, TAB, hyprexpo:expo, toggle"
        ];

        bindm = let
          mousebutton = index: "mouse:${toString (index + 271)}";
        in [
          "$mod, ${mousebutton 1}, movewindow"
          "$mod, ${mousebutton 2}, resizewindow"
        ];

        input = {
          follow_mouse = 2;
          float_switch_override_focus = 0;
          special_fallthrough = true;
        };

        "misc:middle_click_paste" = false;
        # windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.
      };

      plugins = [
        pkgs.hyprlandPlugins.hyprexpo
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
  };
}
