{
  config,
  pkgs,
  ...
}: let
  immichHost = "immich.services.gabrieltb.me";
in {
  services.immich = {
    enable = true;
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
  };
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

  services.caddy = {
    enable = true;
    virtualHosts."immich.services.gabrieltb.me".extraConfig = ''
      reverse_proxy http://127.0.0.1:2283
    '';
  };

  fileSystems = {
    "/vms" = pkgs.lib.mkForce {
      device = "/dev/sda1";
      fsType = "btrfs";
      options = ["subvol=@vms" "noatime"];
    };
  };
}
