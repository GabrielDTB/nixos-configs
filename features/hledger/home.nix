{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      hledger
    ];
    sessionVariables = {
      LEDGER_FILE = "$HOME/accounting/2025.journal";
    };
  };
}
