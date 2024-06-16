{inputs, outputs, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Build tools.
    clang
    gcc
    gnumake
    valgrind
    
    # Languages I want available at all times.
    rust-bin.stable.latest.default
  ];
}
