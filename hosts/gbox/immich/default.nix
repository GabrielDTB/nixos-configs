{
  config,
  pkgs,
  ...
}: {
  services.immich = {
    enable = true;
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
  };
  users.users.immich.extraGroups = ["video" "render"];

  services.nginx = {
    enable = true;
    virtualHosts."immich.services.gabrieltb.me" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.immich.port}";
        proxyWebsockets = true;
      };
      # https://immich.app/docs/administration/reverse-proxy
      extraConfig = ''
        client_max_body_size 50000M;
      '';
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabriel@gabrieltb.me";
  };
  networking.firewall.allowedTCPPorts = [80 443];

  systemd.services.kopia = {
    description = "Kopia backup";
    after = ["network.target"];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "kopia-backup-script.sh" ''
          set -eou pipefail

          ${pkgs.kopia}/bin/kopia snapshot create /immich/photos/
          ${pkgs.kopia}/bin/kopia snapshot create /immich/database_backups/
          ${pkgs.kopia}/bin/kopia snapshot create /var/lib/immich/
        ''
      );
    };
  };
  systemd.timers.kopia = {
    description = "Kopia backup schedule";
    timerConfig = {
      User = "root";
      Unit = "oneshot";
      OnBootSec = "1h";
      OnUnitActiveSec = "1h";
    };
    wantedBy = ["timers.target"];
  };
}
