{...}: {
  imports = [
    ((import ../../../features/utils.nix).getStandaloneFeatures "slugbox" "gilberto" [
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
      /starship
      /tmux
      /zellij
    ])
  ];

  targets.genericLinux.enable = true;
}
