
{ pkgs, ... }:

{
  users.users.gabe = {
    isNormalUser = true;
    createHome = true;
    home = "/home/gabe";
    group = "users";
    extraGroups = [ "wheel" "video" "audio" "disk" ];
    uid = 1000;
  };
}
