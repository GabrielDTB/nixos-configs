{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
    graalvmPackages.graalvm-oracle_25
  ];
}
