{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unstable.signal-desktop
  ];
}
