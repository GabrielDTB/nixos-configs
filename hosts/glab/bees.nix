{...}: {
  services.beesd.filesystems = {
    root = {
      spec = "LABEL=nixos";
      hashTableSizeMB = 2048;
      verbosity = "crit";
      extraOptions = ["--loadavg-target" "2.0"];
    };
  };
}
