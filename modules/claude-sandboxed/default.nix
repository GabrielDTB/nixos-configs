{
  home-manager = {inputs, ...}: {imports = [inputs.claude-sandboxed.homeManagerModules.default];};
  nixos = {inputs, ...}: {imports = [inputs.claude-sandboxed.nixosModules.default];};
}
