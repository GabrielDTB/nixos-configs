{pkgs, ...}: {
  # Enable joystick support
  # services.xserver.inputClassSections = [
  #   ''
  #     Identifier "Joystick catchall"
  #     MatchIsJoystick "on"
  #     MatchDevicePath "/dev/input/event*"
  #     Driver "joystick"
  #     Option "StartKeysEnabled" "False"
  #     Option "StartMouseEnabled" "False"
  #   ''
  # ];

  # # Add udev rules for DS4
  # services.udev.extraRules = ''
  #   KERNEL=="js*", SUBSYSTEM=="input", ATTRS{name}=="*Wireless Controller", MODE="0666"
  #   KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="*Wireless Controller", MODE="0666"
  # '';

  # # Make sure you have the required packages
  # environment.systemPackages = with pkgs; [
  #   linuxConsoleTools  # for jstest
  #   evtest
  # ];
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="input", ATTRS{name}=="Wireless Controller", MODE="0666", SYMLINK+="dualshock4-bt"
  #   SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
  #   SUBSYSTEM=="input", ATTRS{name}=="*Controller Touchpad", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
  # '';
}
