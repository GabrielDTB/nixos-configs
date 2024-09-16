{
  mkFeature,
  pkgs,
  ...
}:
mkFeature {
  name = "tuigreet";
  body = {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd "hyprland >/dev/null"'';
          user = "greeter";
        };
      };
    };
  };
}
