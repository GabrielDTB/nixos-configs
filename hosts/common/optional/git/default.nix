{...}: {
  programs.git = {
    enable = true;
    config = {
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
  };
}
