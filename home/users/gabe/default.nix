{
  outputs,
  pkgs,
  config,
  ...
}: {
  home = {
    username = "gabe";
    homeDirectory = "/home/gabe";
  };
  imports = [
    ./features
    # ./direnv
    # ./git
    # ./hledger
    ./kitty
    # ./neovim
    # ./obsidian
    # ./osu
    # ./signal
    # ./starship
    ./sway
    ./theming
    ./hyprland.nix
    # ./tofi
    # ./vlc
    # ./zsh

    # ./applications/bundles/media
    # ./applications/bundles/internet
    # ./applications/bundles/games
    # ./applications/bundles/productivity
    # ./applications/bundles/communication
  ];

  programs.git = {
    enable = true;
    userName = "Gabriel Talbert Bunt";
    userEmail = "gabriel@gabrieltb.me";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      "screenshare" = "wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "areashare" = "wf-recorder -g \"$(slurp)\" --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "ls" = "eza";
      "ll" = "eza -l";
      "la" = "eza -a";
      "lla" = "eza -la";
      "lal" = "eza -al";
      "nrs" = "sudo nixos-rebuild switch";
      "nrb" = "sudo nixos-rebuild boot";
      "cd" = "z";
    };
    history = {
      size = 10000;
      path = "$HOME/.config/zsh/.zsh_history";
    };
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # setOptions = [
    #   "AUTO_CD"
    #   "CHASE_DOTS"
    #   "HIST_IGNORE_DUPS"
    #   "INC_APPEND_HISTORY"
    #   "HIST_FCNTL_LOCK"
    #   "HIST_FIND_NO_DUPS"
    #   "EXTENDED_HISTORY"
    # ];
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    pavucontrol
    # sl
    # noto-fonts
    # noto-fonts-extra
    # noto-fonts-emoji
    # babelstone-han
    # cmatrix
    # airshipper
    # prismlauncher
    # digikam
    # imhex
    # rstudio
    # p7zip
    # qbittorrent
    # kopia
    # lutris
    wineWowPackages.staging
    # winetricks
    # croc
    # lazygit
    # qrencode
    # ardour
    # eclipses.eclipse-java
  ];

  gtk = {
    enable = true;
    # theme = {
    #   name = "Materia-dark";
    #   package = pkgs.materia-theme;
    # };
  };

  fonts.fontconfig.enable = true;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
