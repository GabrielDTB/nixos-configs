{ outputs, pkgs, ... }: 

{
  home = {
    username = "gabe";
    homeDirectory = "/home/gabe";
    shellAliases = {
      "screenshare" = "wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
      "areashare" = "wf-recorder -g \"$(slurp)\" --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p -tD";
    };
  };

  imports = [
    ./kitty
    ./sway
    ./git
    ./neovim
    ./firefox
    ./helix
    ./osu
    ./obsidian
  ];  
  
  home.packages = with pkgs; [
    kitty
    signal-desktop
    pavucontrol
    sl
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    babelstone-han
    cmatrix
    airshipper
    prismlauncher
    digikam
    imhex
  ];

  fonts.fontconfig.enable = true;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
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
      allowUnfreePredicate = (_: true);
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
