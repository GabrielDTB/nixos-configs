{pkgs, ...}: {
  home.packages = with pkgs; [
    claude-sandboxed
  ];
}
