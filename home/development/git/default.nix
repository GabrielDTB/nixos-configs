{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Gabriel Talbert Bunt";
    userEmail = "gabriel@gabrieltb.me";
    package = pkgs.gitFull;
    extraConfig  = { 
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
    
    # aliases = {
    #   reset = "reset HEAD --";
    #   master = "checkout master";
    #   main = "checkout main";
    #   pushf = "push - force-with-lease";
    #   hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
    # };
  };
}
