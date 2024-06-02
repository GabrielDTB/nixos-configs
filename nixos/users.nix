{pkgs, ...}: {
  users.users.gabe = {
    isNormalUser = true;
    createHome = true;
    home = "/home/gabe";
    group = "users";
    extraGroups = ["wheel" "video" "audio" "disk" "libvirtd"];
    uid = 1000;
    shell = pkgs.zsh;
  };
  users.users.tamy = {
    isNormalUser = true;
    createHome = true;
    home = "/home/tamy";
    group = "users";
    uid = 1001;
    shell = pkgs.zsh;
  };
}
