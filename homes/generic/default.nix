{...}: {
  imports = [
    ((import ../../features/utils.nix).getHomeImports "generic" [
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

  # Not NixOS: pick up /usr/share, the distro's terminfo, and the system nix
  # profile. Drop this if a standalone home ever lands on a NixOS box.
  targets.genericLinux.enable = true;
}
