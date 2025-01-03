{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
    user = "gabe";
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
