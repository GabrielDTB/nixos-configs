
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    btop
    which
    git
    nix-prefetch-scripts
    cryptsetup
    tmux
    greetd.tuigreet
    helix
    v4l-utils
    ffmpeg
    slurp
    grim
    wf-recorder-fix
  ];
}
