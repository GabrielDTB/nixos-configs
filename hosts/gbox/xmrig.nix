{pkgs, ...}: {
  services.xmrig = {
    enable = true;
    package = pkgs.unstable.xmrig;
    settings = {
      autosave = true;
      cpu = {
        enable = true;
        priority = 1;
        max-threads-hint = 33;
      };
      opencl = false;
      # opencl = {
      #   enabled = true;
      #   # loader = "/opt/rocm/icd/etc/OpenCL/vendors/amdocl64.icd";
      #   loader = "/opt/rocm/hip/lib/libOpenCL.so";
      #   # platform = "AMD Accelerated Parallel Processing";
      #   platform = 0;
      # };

      cuda = false;
      pools = [
        {
          url = "pool.supportxmr.com:443";
          user = "42GtCTb4TzYSKQYyRNihd9bUAwAwjngFq32zEQbz7TkJ9ZSoEAtZKEkYg85TwVLktRiiQ2HwT3MoRXBX6DRuiyyo15YswNS";
          pass = "snowbound3326";
          keepalive = true;
          tls = true;
        }
      ];
      # priority = 1;
    };
  };
}
