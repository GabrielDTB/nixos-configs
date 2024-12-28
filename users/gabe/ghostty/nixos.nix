{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    master.ghostty
  ];
}
