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
    # distributedBuilds = true;
    # buildMachines = [];
    # settings = {
    #   substituters = [
    #     # "ssh-ng://nixbuilder@"
    #   ];
    #   trusted-substituters = [
    #     # "ssh-ng://nixbuilder@g"
    #   ];
    #   builders-use-substitutes = true;
    # };
  };
}
