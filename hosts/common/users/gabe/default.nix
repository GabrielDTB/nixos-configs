{pkgs, ...}: {
  home-manager.users.gabe = {
    imports = [../../../../home/gabe];
    features.nixos.enable = true;
  };

  users.users.gabe = with pkgs; {
    isNormalUser = true;
    createHome = true;
    home = "/home/gabe";
    group = "users";
    extraGroups = ["wheel" "video" "audio" "disk" "libvirtd" "render" "adbusers"];
    uid = 1000;
    shell = zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWwpJxQlIenoxGRuVSjI9soGmEWxe9Wnql4UcNg+g0"
    ];
  };
}
