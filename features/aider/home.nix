{pkgs, ...}: {
  home.packages = with pkgs; [
    aider-chat
  ];
  programs.git.ignores = [
    ".aider*"
  ];
}
