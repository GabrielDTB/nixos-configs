{pkgs, ...}: {
  imports = [
    ./software/direnv
    ./software/git
    ./software/hledger
    ./software/obsidian
    #/software ./osu
    ./software/signal
    ./software/starship
    ./software/zsh
  ];

  environment.systemPackages = with pkgs; [
    croc
    kopia
    lazygit
    qbittorrent
    p7zip
    prismlauncher
    vlc
  ];
}
