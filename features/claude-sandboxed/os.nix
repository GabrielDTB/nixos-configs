{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
    };
  };

  programs.claude-sandboxed = {
    enable = true;
    sharedLimit = {
      enable = true;
    };
  };
}
