{pkgs, ...}: {
  home.packages = with pkgs; [
    coreutils-full
    wget
    curl
    which
    unzip
    zip
  ];
}
