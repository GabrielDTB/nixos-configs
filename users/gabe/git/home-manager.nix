{...}: {
  programs.git = {
    enable = true;
    userName = "Gabriel Talbert Bunt";
    userEmail = "gabriel@gabrieltb.me";
    extraConfig = {
      credential = {
        helper = "store";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
