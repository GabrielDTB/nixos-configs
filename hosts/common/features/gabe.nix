{
  pkgs,
  mkFeature,
  ...
}:
mkFeature {
  name = "gabe";
  enableDefault = true;
  body = {
    features = {
      home-manager.enable = true;
    };

    home-manager.users.gabe = {
      imports = [../../../home/gabe];
      features.nixos.enable = true;
    };

    users.users.gabe = with pkgs; {
      isNormalUser = true;
      # createHome = true;
      # home = "/home/gabe";
      # group = "users";
      extraGroups = ["wheel" "video" "audio" "disk" "libvirtd" "render" "adbusers" "input"];
      uid = 1000;
      shell = zsh;
      ignoreShellProgramCheck = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8Aa9Q+Wf1YFi0XqG/5OK0RruJL7ItRQKLQtMVUsIIn gabriel@gabrieltb.me"
      ];
    };
  };
}
