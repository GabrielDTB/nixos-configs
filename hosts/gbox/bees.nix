{...}: {
  services.beesd.filesystems = {
    root = {
      spec = "LABEL=nixos";
      hashTableSizeMB = 1024;
      verbosity = "crit";
      extraOptions = ["--loadavg-target" "2.0"];
    };
    ssd = {
      spec = "LABEL=ssd";
      hashTableSizeMB = 512;
      verbosity = "crit";
      extraOptions = ["--loadavg-target" "2.0"];
    };
    data = {
      spec = "LABEL=data";
      hashTableSizeMB = 3072;
      verbosity = "crit";
      extraOptions = ["--loadavg-target" "2.0"];
    };
    enclave = {
      spec = "LABEL=enclave";
      hashTableSizeMB = 128;
      verbosity = "crit";
      extraOptions = ["--loadavg-target" "2.0"];
    };
  };
}
