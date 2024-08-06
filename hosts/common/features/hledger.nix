{
  mkFeature,
  lib,
  pkgs,
  config,
  ...
}:
mkFeature {
  name = "hledger";
  body = {
    environment = {
      systemPackages = with pkgs; [
        hledger
      ];
      sessionVariables = {
        LEDGER_FILE = "$HOME/accounting/2024.journal";
      };
    };

    systemd = lib.mkIf config.features.kopia.enable {
      services.accounting-backup = {
        description = "Accounting backup";
        after = ["network.target"];
        serviceConfig = {
          User = "root";
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "accounting-backup.sh" ''
              set -eou pipefail

              ${pkgs.kopia}/bin/kopia snapshot create /home/gabe/accounting
            ''
          );
        };
      };
      timers.accounting-backup = {
        description = "Accounting backup schedule";
        timerConfig = {
          User = "root";
          Unit = "oneshot";
          OnBootSec = "1h";
          OnUnitActiveSec = "1h";
        };
        wantedBy = ["timers.target"];
      };
    };
  };
}
