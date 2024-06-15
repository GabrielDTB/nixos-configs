{pkgs, ...}: {
  # Obsidian unfortunately uses electron 24.8.6.
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  # I use syncthing to syncronize the obsidian vault across devices.
  services.syncthing = {
    enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    obsidian
  ];
}

