{
  config,
  pkgs,
  ...
}: let
  immichHost = "immich.services.gabrieltb.me";

  immichRoot = "/immich";
  immichPhotos = "${immichRoot}/photos";
  immichAppdataRoot = "${immichRoot}/appdata";
  immichVersion = "v1.112.1";

  postgresRoot = "${immichAppdataRoot}/pgsql";
  postgresPassword = "hunter2"; # TODO: use secrets (is this necessary?)
  postgresUser = "immich";
  postgresDb = "immich";
  postgresBackupRoot = "${immichRoot}/database_backups";

  extraOptions = [
    # Force DNS resolution to only be the podman dnsname name server; by default podman provides a resolv.conf
    # that includes both this server and the upstream system server, causing resolutions of other pod names
    # to be inconsistent.
    "--pull=newer"
    # "--dns=10.88.0.1"
    "--network=immich-network"
  ];
in {
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
        ''
      );
    };
    # Install.WantedBy = [ "default.target" ];
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

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.firewall.interfaces."podman+".allowedUDPPorts = [53 5353];
  networking.firewall.allowedTCPPorts = [80 443];
  # networking.firewall.enable = false;
  # To make redis happy.
  boot.kernel.sysctl = {"vm.overcommit_memory" = 1;};

  systemd.services.create-immich-network = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [
      "${backend}-immich_server.service"
      "${backend}-immich_microservices.service"
      "${backend}-immich_machine_learning.service"
      "${backend}-immich_redis.service"
      "${backend}-immich_postgres.service"
    ];
    script = ''
      ${pkgs.podman}/bin/podman network exists immich-network || \
      ${pkgs.podman}/bin/podman network create immich-network
    '';
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."${immichHost}" = {
    extraConfig = ''
      ## Per https://immich.app/docs/administration/reverse-proxy...
      client_max_body_size 50000M;
    '';
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "gabriel@gabrieltb.me";
  };

  # The primary source for this configuration is the recommended docker-compose installation of immich from
  # https://immich.app/docs/install/docker-compose, which linkes to:
  # - https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
  # - https://github.com/immich-app/immich/releases/latest/download/example.env
  # and has been transposed into nixos configuration here.  Those upstream files should be checked
  # for serious changes if there are any upgrade problems here.
  #
  # After initial deployment, these in-process configurations need to be done:
  # - create an admin user by accessing the site
  # - login with the admin user
  # - set the "Machine Learning Settings" > "URL" to http://immich_machine_learning:3003

  virtualisation.oci-containers.containers = {
    immich_server = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      volumes = [
        "${immichPhotos}:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        IMMICH_VERSION = immichVersion;
        DB_HOSTNAME = "immich_postgres";
        DB_USERNAME = postgresUser;
        DB_DATABASE_NAME = postgresDb;
        DB_PASSWORD = postgresPassword;
        REDIS_HOSTNAME = "immich_redis";
      };
      ports = ["127.0.0.1:2283:3001"];
      dependsOn = [
        "immich_redis"
        "immich_postgres"
      ];
      extraOptions = extraOptions;
    };

    immich_machine_learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
      volumes = ["${immichAppdataRoot}/model-cache:/cache"];
      environment = {
        IMMICH_VERSION = immichVersion;
      };
      extraOptions = extraOptions;
    };

    immich_redis = {
      image = "registry.hub.docker.com/library/redis:6.2-alpine@sha256:84882e87b54734154586e5f8abd4dce69fe7311315e2fc6d67c29614c8de2672";
      extraOptions = extraOptions;
    };

    immich_postgres = {
      image = "registry.hub.docker.com/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
      volumes = ["${postgresRoot}:/var/lib/postgresql/data"];
      environment = {
        POSTGRES_PASSWORD = postgresPassword;
        POSTGRES_USER = postgresUser;
        POSTGRES_DB = postgresDb;
        POSTGRES_INITDB_ARGS = "--data-checksums";
      };
      extraOptions = extraOptions;
    };

    immich_postgres_backup = {
      image = "prodrigestivill/postgres-backup-local:14";
      volumes = ["${postgresBackupRoot}:/database_backups"];
      environment = {
        POSTGRES_PASSWORD = postgresPassword;
        POSTGRES_USER = postgresUser;
        POSTGRES_DB = postgresDb;
        POSTGRES_INITDB_ARGS = "--data-checksums";
        POSTGRES_HOST = "immich_postgres";
        SCHEDULE = "@daily";
        BACKUP_NUM_KEEP = "7";
        BACKUP_DIR = "/database_backups";
      };
      extraOptions = extraOptions;
    };
  };

  fileSystems = {
    "/vms" = pkgs.lib.mkForce {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = ["subvol=@vms" "noatime"];
    };
  };
}
