{
  config,
  pkgs,
  ...
}: let
  immich-rawstack = pkgs.rustPlatform.buildRustPackage {
    pname = "immich-rawstack";
    version = "0.1.0";
    src = ./immich-rawstack;
    cargoLock.lockFile = ./immich-rawstack/Cargo.lock;
  };

  apiKeyFile = "/var/lib/secrets/immich-go-api-key";
  server = "http://localhost:${toString config.services.immich.port}";

  stackScript = pkgs.writeShellScript "immich-stack" ''
    set -euo pipefail
    export IMMICH_URL="${server}"
    export IMMICH_API_KEY_FILE="$CREDENTIALS_DIRECTORY/api-key"
    export RAWSTACK_COVER=jpeg
    exec ${immich-rawstack}/bin/immich-rawstack "$@"
  '';
in {
  systemd.services.immich-stack = {
    description = "Stack RAW+JPEG pairs in Immich";
    after = ["immich-server.service"];
    requires = ["immich-server.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${stackScript}";
      LoadCredential = ["api-key:${apiKeyFile}"];
      StateDirectory = "immich-stack"; # cursor -> /var/lib/immich-stack/cursor

      DynamicUser = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      NoNewPrivileges = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      SystemCallArchitectures = "native";
    };
  };

  systemd.timers.immich-stack = {
    description = "Periodic RAW+JPEG stacking for Immich";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "2min";
      Persistent = true;
    };
  };
}
