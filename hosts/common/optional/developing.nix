{inputs, outputs, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rust-bin.stable.latest.default
  ];
}
