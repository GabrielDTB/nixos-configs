{inputs, outputs, ...}: {
  imports = [
    ../common/global
    ../common/users/gabe

    ../common/optional/developing.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };
}
