{mkFeature, ...}:
mkFeature {
  name = "tamy";
  body = {
    users.users.tamy = {
      isNormalUser = true;
      uid = 1001;
      # shell = zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGen0SD+FLfJBQXRl7eEntG+DSKscR2JOi1BF/bRdc9a for_gabee"
      ];
    };
  };
}
