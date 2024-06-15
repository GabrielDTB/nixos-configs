{pkgs, ...}: {
  imports = [
    ./direnv
    ./git
    ./hledger
    ./obsidian
    # ./osu
    ./signal
    ./starship
    ./zsh
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
