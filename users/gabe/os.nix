{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  users.users.gabe = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "disk" "render" "adbusers" "input"];
    uid = 1000;
  };

  nix.settings.trusted-users = [
    "@wheel"
  ];
}
