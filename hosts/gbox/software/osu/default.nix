{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unstable.osu-lazer-bin
  ];
}
