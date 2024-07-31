{mkFeature, ...}:
mkFeature {
  name = "ssh-daemon";
  body = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = true;
      };
    };
  };
}
