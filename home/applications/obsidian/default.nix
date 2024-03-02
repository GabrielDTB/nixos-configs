{pkgs, ...}: {
  # Obsidian unfortunately uses electron 24.8.6.
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];
  # I use syncthing to syncronize the obsidian vault accross devices.
  services.syncthing = {
    enable = true;
  };
  home.packages = with pkgs; [
    obsidian
  ];
}
