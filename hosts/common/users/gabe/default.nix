{pkgs, ...}: {
  home-manager.users.gabe = {
    imports = [../../../../home];
  };
  users.users.gabe = with pkgs; {
    isNormalUser = true;
    createHome = true;
    home = "/home/gabe";
    group = "users";
    extraGroups = ["wheel" "video" "audio" "disk" "libvirtd"];
    uid = 1000;
    shell = zsh;
  };
}
