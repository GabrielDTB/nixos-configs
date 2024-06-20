{inputs, outputs, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Basics.
    git
    
    # Build tools.
    clang
    gcc
    gnumake
    valgrind
    
    # Languages I want available at all times.
    rust-bin.stable.latest.default
  ];

  programs = {
    # Automatically enter development environments.
    direnv.enable = true;
  };
}
