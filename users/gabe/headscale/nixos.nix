{config, ...}: 
{
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 50697;
      settings = {
        server_url = "https://headscale.services.gabrieltb.me";
        dns = {
          base_domain = "tailnet.services.gabrieltb.me";
          magic_dns = true;
          nameservers.global = [
            "1.1.1.1"
            "9.9.9.9"
          ];
        };
        logtail.enabled = false;
      };
    };

    nginx.virtualHosts."headscale.services.gabrieltb.me" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.headscale.port}";
        proxyWebsockets = true;
      };
    };
  };

  # # DERP port (https://tailscale.com/kb/1082/firewall-ports)
  # networking.firewall.allowedUDPPorts = [3478];

  environment.systemPackages = [ config.services.headscale.package ];
}
