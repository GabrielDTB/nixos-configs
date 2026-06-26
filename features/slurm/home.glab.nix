{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      jarvis = {
        HostName = "155.246.125.20";
        User = "gtalbert";
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%r@%h:%p";
        ControlPersist = "yes";
      };
    };
  };
}
