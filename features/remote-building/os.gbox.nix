{...}: {
  users.users.nixbuilder = {
    isSystemUser = true;
    group = "nixbuilder";
    shell = "/run/current-system/sw/bin/bash";
    openssh.authorizedKeys.keys = [];
  };
  users.groups.nixbuilder = {};
  nix.settings.trusted-users = ["nixbuilder"];

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "glab";
        sshUser = "nixbuilder";
        sshKey = "/root/.ssh/nixbuilder_ed25519";
        system = "x86_64-linux";
        maxJobs = 20;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    settings = {
      substituters = [
        "ssh-ng://nixbuilder@glab?ssh-key=/root/.ssh/nixbuilder_ed25519"
      ];
      trusted-substituters = [
        "ssh-ng://nixbuilder@glab?ssh-key=/root/.ssh/nixbuilder_ed25519"
      ];
      builders-use-substitutes = true;
    };
  };
}
