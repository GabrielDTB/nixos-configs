{
  pkgs,
  lib,
  ...
}: let
  asset = "XMR";
  withdrawKey = "Hot XMR";
  maxFeeFraction = 0.01;
  credentialsFile = "/var/lib/secrets/kraken-autowithdraw"; # KRAKEN_API_KEY=... / KRAKEN_API_SECRET=..., root-only, outside the store
  schedule = "daily";

  sweep = pkgs.writers.writePython3Bin "kraken_sweep" {} (builtins.readFile ./kraken_sweep.py);
in {
  systemd.services.kraken-sweep = {
    description = "Sweep ${asset} from Kraken to ${withdrawKey}";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    environment = {
      KRAKEN_ASSET = asset;
      KRAKEN_WITHDRAW_KEY = withdrawKey;
      KRAKEN_MAX_FEE_FRACTION = toString maxFeeFraction;
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe sweep;
      LoadCredential = ["kraken:${credentialsFile}"];

      DynamicUser = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service" "~@privileged"];
      CapabilityBoundingSet = "";
    };
  };

  systemd.timers.kraken-sweep = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = schedule;
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
