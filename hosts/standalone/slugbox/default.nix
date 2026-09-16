{lib, ...}: {
  imports = [
    ((import ../../../features/utils.nix).getStandaloneFeatures "gilberto" ["slugbox"] [
      /basic-utils
      /btop
      /core-replacements
      /croc
      /devenv
      /direnv
      /fish
      /git
      /helix
      /lazygit
      /nix-index
      /scripts
      /ssh
      /starship
      /tmux
      /zellij
    ])
  ];

  targets.genericLinux.enable = true;

  # Systemd can't use the chroot nix store.
  systemd.user.enable = lib.mkForce false;
  nix.gc.automatic = lib.mkForce false;
}
