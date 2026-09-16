{...}: {
  imports = [
    ((import ../../../features/utils.nix).getHomeImports "generic" [
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
    username = "gabe";
    homeDirectory = "/home/gabe";
  };

  targets.genericLinux.enable = true;
}
