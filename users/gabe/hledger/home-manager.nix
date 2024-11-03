{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      hledger
    ];
    sessionVariables = {
      LEDGER_FILE = "$HOME/accounting/2024.journal";
    };
  };
}
