{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    btop
    which
    git
    nix-prefetch-scripts
    cryptsetup
    greetd.tuigreet
    helix
    v4l-utils
    ffmpeg
    slurp
    grim
    wf-recorder-fix
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
    curl
    gnumake
    clang
    gcc
    valgrind
    coreutils
    unstable.eza
    unzip
    zip
  ];

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -sg escape-time 0
    '';
  };

  programs.zsh.enable = true;
}
