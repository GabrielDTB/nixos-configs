{
  mkFeature,
  ...
}:
mkFeature {
  name = "printing";
  body = {
    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
