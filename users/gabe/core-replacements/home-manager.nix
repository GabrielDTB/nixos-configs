{...}: {
  programs = {
    eza.enable = true;
    zoxide.enable = true;
    ripgrep.enable = true;
  };

  home.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    la = "eza -a";
    lla = "eza -la";
    lal = "eza -al";

    cd = "z";

    grep = "rg";
  };
}