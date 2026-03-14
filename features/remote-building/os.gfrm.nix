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
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
      {
        hostName = "gbox";
        sshUser = "nixbuilder";
        sshKey = "/root/.ssh/nixbuilder_ed25519";
        system = "x86_64-linux";
        maxJobs = 12;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
      {
        hostName = "viper";
        sshUser = "nixbuilder";
        sshKey = "/root/.ssh/nixbuilder_ed25519";
        system = "x86_64-linux";
        maxJobs = 10;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    settings = {
      substituters = [
        "ssh-ng://nixbuilder@glab"
        "ssh-ng://nixbuilder@gbox"
        "ssh-ng://nixbuilder@viper"
      ];
      trusted-substituters = [
        "ssh-ng://nixbuilder@glab"
        "ssh-ng://nixbuilder@gbox"
        "ssh-ng://nixbuilder@viper"
      ];
      trusted-public-keys = [
        "glab:76G8OEpinHFQt0TjxstknfPgdK8oyRDEBcHZRPLw1zk="
        "gbox:5LjczQbox0CdLxOyQy/9dv+lLVebC1Nf6mZ3Edae0NI="
        "viper-1:ixVXU1FrvL2pgNGE2Jez6Bk9maoyKiD0ddHxEY+bGkQ="
      ];
      builders-use-substitutes = true;
    };
  };

  home-manager.users.root = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        glab = {
          user = "nixbuilder";
          identityFile = "/root/.ssh/nixbuilder_ed25519";
        };
        gbox = {
          user = "nixbuilder";
          identityFile = "/root/.ssh/nixbuilder_ed25519";
        };
        viper = {
          hostname = "155.246.81.47";
          user = "nixbuilder";
          identityFile = "/root/.ssh/nixbuilder_ed25519";
          proxyJump = "glab";
        };
      };
    };
    home.stateVersion = "23.05";
  };
}
