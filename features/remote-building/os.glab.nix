{...}: {
  users.users.nixbuilder = {
    isSystemUser = true;
    group = "nixbuilder";
    shell = "/run/current-system/sw/bin/bash";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzRci0GQjuVeBYEUcpFlPdbIoKEL7Njrbdsss/yTd00 nixbuilder"
    ];
  };
  users.groups.nixbuilder = {};
  nix.settings.trusted-users = ["nixbuilder"];

  nix = {
    distributedBuilds = true;
    buildMachines = [
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
        "ssh-ng://nixbuilder@viper"
      ];
      trusted-substituters = [
        "ssh-ng://nixbuilder@viper"
      ];
      trusted-public-keys = [
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
