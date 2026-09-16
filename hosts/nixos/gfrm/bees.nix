{...}: {
  services.beesd.filesystems = {
    root = {
      spec = "/dev/mapper/vg1-root";
      hashTableSizeMB = 512;
      verbosity = "crit";
      extraOptions = ["--loadavg-target" "1.0"];
    };
  };
}
