{
  config,
  lib,
  pkgs,
  ...
}: let
  snapshotPaths = [
    "/home/gabe/Enclave/Zettelkasten"
    "/srv/immich-media"
    "/home/gabe/Videos/qbittorrent/RED"
  ];
in {
  systemd.services.kopia-backup = {
    confinement.enable = true;

    environment = {
      KOPIA_CONFIG_PATH = "/var/lib/kopia/repository.config";
      KOPIA_CACHE_DIRECTORY = "/var/cache/kopia";
      KOPIA_CHECK_FOR_UPDATES = "false";
      HOME = "/var/cache/kopia";
      # SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    script = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export KOPIA_PASSWORD="$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/kopia-password")"
      if [ ! -f "$KOPIA_CONFIG_PATH" ]; then
        export AWS_ACCESS_KEY_ID="$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/b2-key-id")"
        export AWS_SECRET_ACCESS_KEY="$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/b2-app-key")"
        ${pkgs.kopia}/bin/kopia repository connect s3 \
          --bucket=gtb-kopia \
          --endpoint=s3.us-east-005.backblazeb2.com \
          --override-username=gabe \
          --override-hostname=gbox
      fi
      exec ${pkgs.kopia}/bin/kopia snapshot create \
        ${lib.escapeShellArgs snapshotPaths}
    '';

    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      StateDirectory = "kopia";
      CacheDirectory = "kopia";
      LoadCredential = [
        "kopia-password:/root/kopia-password"
        "b2-key-id:/root/b2-key-id"
        "b2-app-key:/root/b2-app-key"
      ];

      AmbientCapabilities = ["CAP_DAC_READ_SEARCH"];
      CapabilityBoundingSet = ["CAP_DAC_READ_SEARCH"];

      BindReadOnlyPaths =
        snapshotPaths
        ++ [
          "-/etc/resolv.conf"
          "-/run/systemd/resolve"
        ];

      PrivateUsers = lib.mkForce false;
      NoNewPrivileges = true;
      PrivateDevices = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectHostname = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service"];
      UMask = "0077";
      ProtectKernelLogs = true;
      RestrictRealtime = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      MemoryDenyWriteExecute = true;
    };
  };

  systemd.timers.kopia-backup = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
  };
}
