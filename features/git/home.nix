{...}: {
  programs.git = {
    enable = true;
    ignores = [
      "/.envrc"
      "/.direnv/"
    ];
    settings = {
      user = {
        name = "Gabriel Talbert Bunt";
        email = "gitcommit@dendry.net";
      };
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
