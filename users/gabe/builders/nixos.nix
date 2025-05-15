{...}: {
  nix = {
    buildMachines = [
      {
        hostName = "gbox";
        sshUser = "gabe";
        system = "x86_64-linux";
        sshKey = "/home/gabe/.ssh/id_ed25519";
        protocol = "ssh-ng";
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        # maxJobs = 1;
        # speedFactor = 1;
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
    # settings = {
    #   trusted-public-keys = [
    #     "builder-cache:p97XQWA2Oo66nK/PcKz0q1U64dUw0FkuHLdo+y4jxQI="
    #   ];
    #   substituters = [
    #     "ssh-ng://builder"
    #   ];
    # };
  };
}
