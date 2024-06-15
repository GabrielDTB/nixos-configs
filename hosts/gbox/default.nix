{inputs, outputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    
    ../common/global
    ../common/users/gabe
    ../common/users/tamy

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
