{mkFeature, ...}:
mkFeature {
  name = "bluetooth";
  body = {
    hardware = {
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
}
