{pkgs, ...}: {
  users.users.tamy = with pkgs; {
    isNormalUser = true;
    createHome = true;
    home = "/home/tamy";
    group = "users";
    uid = 1001;
    shell = zsh;
  };
}
