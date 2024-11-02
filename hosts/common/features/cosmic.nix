{
  mkFeature,
  ...
}:
mkFeature {
  name = "cosmic";
  body = {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
