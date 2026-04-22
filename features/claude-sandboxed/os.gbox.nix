{...}: {
  services.claude-proxy = {
    enable = true;
    bind = "100.64.0.5:18080";
  };

  programs.claude-sandboxed = {
    sharedLimit = {
      memoryGB = 20;
    };
  };
}
