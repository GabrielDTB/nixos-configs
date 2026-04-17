{...}: {
  services.claude-proxy = {
    enable = true;
    bind = "100.64.0.5:18080";
  };
}
