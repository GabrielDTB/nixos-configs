{pkgs, ...}: {
  programs = {
    eza.enable = true;
    zoxide.enable = true;
    ripgrep = {
      enable = true;
      package = pkgs.ripgrep-all;
    };
    bat.enable = true;
    fzf.enable = true;
  };

  # Not cross-shell. Whatever.
  programs.zsh.initExtra = "source ${./rga-fzf.sh}";

  home.shellAliases = {
    ls = "eza";
    ll = "eza -l";
    la = "eza -a";
    lla = "eza -la";
    lal = "eza -al";

    cd = "z";

    grep = "rga";

    cat = "bat";
  };
}
