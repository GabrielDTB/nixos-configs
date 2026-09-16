{...}: {
  imports = [
    ((import ../../../features/utils.nix).getHomeImports "slugbox" [
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

  home = {
    username = "gilberto";
    homeDirectory = "/home/gilberto";
  };

  targets.genericLinux.enable = true;
}
