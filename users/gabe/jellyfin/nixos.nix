{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
    user = "gabe";
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
