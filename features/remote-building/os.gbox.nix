{...}: {
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "glab";
        sshUser = "nixbuilder";
        sshKey = "/root/.ssh/nixbuilder_ed25519";
        system = "x86_64-linux";
        maxJobs = 20;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];

    # Optional but recommended: use the remote builder's store as a substituter
    # so your local machine doesn't rebuild things the remote already has
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
