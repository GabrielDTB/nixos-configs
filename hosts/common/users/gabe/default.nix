{pkgs, ...}:{
  users.users.gabe = {
    isNormalUser = true;
    createHome = true;
    home = "/home/gabe";
    group = "users";
    extraGroups = ["wheel" "video" "audio" "disk" "libvirtd"];
    uid = 1000;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxWwpJxQlIenoxGRuVSjI9soGmEWxe9Wnql4UcNg+g0" # content of authorized_keys file
    ];
  };
}
