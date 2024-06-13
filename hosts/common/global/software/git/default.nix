{...}: {
  programs.git = {
    enable = true;
    config = {
      user.name = "Gabriel Talbert Bunt";
      user.email = "gabriel@gabrieltb.me";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
  };
}
