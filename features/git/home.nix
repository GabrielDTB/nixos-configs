{...}: {
  programs.git = {
    enable = true;
    userName = "Gabriel Talbert Bunt";
    userEmail = "gabriel@gabrieltb.me";
    ignores = [
      "/.envrc"
      "/.direnv/"
    ];
    extraConfig = {
      credential = {
        helper = "store";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
    };
  };
}
