{
  pkgs,
  config,
  ...
}: let
  # pinnedQB =
  #   (import (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/62b852f6c.tar.gz";
  #     sha256 = "04c6dkshw07bm2isv7rvl6xgr4hn7hqznr0v2kww6zjfz4awk4a7";
  #   }) {system = config.nixpkgs.system;}).qbittorrent;
in {
  home.packages = with pkgs; [
    # pinnedQB
    qbittorrent
  ];
}
