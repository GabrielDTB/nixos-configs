{
  outputs,
  pkgs,
  ...
}: {
  home = {
    username = "gabe";
    homeDirectory = "/home/gabe";
  };
  imports = [
    # ./direnv
    ./firefox
    # ./git
    ./helix
    # ./hledger
    ./kitty
    # ./neovim
    # ./obsidian
    # ./osu
    # ./signal
    # ./starship
    ./sway
    ./theming
    # ./tofi
    # ./vlc
    # ./zsh

    # ./applications/bundles/media
    # ./applications/bundles/internet
    # ./applications/bundles/games
    # ./applications/bundles/productivity
    # ./applications/bundles/communication
  ];

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
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };

  fonts.fontconfig.enable = true;

  systemd.user.services.kopia = {
    Unit = {
      Description = "Kopia backup";
      After = ["network.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = toString (
        pkgs.writeShellScript "kopia-backup-script.sh" ''
          set -eou pipefail

          ${pkgs.kopia}/bin/kopia snapshot create /home/gabe/Enclave/Zettelkasten/
          ${pkgs.kopia}/bin/kopia snapshot create /home/gabe/SM-P610/
        ''
      );
    };
    # Install.WantedBy = [ "default.target" ];
  };
  systemd.user.timers.kopia = {
    Unit.Description = "Kopia backup schedule";
    Timer = {
      Unit = "oneshot";
      OnBootSec = "1h";
      OnUnitActiveSec = "1h";
    };
    Install.WantedBy = ["timers.target"];
  };

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
