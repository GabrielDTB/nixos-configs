{pkgs, ...}:{
  users.users.tamy = {
    isNormalUser = true;
    createHome = true;
    home = "/home/tamy";
    group = "users";
    uid = 1001;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGen0SD+FLfJBQXRl7eEntG+DSKscR2JOi1BF/bRdc9a for_gabee"
    ];
  };
}
