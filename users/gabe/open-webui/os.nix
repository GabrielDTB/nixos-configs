{...}: {
  services.open-webui = {
    enable = true;
    port = 33122;
    openFirewall = true;
    host = "0.0.0.0";
  };
}
