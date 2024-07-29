{
  config,
  lib,
  ...
}: let
  # cfg = config.features.core-replacements;
  feature = "core-replacements";
in with lib; {
  imports = [
    ./eza.nix
  ];
  options.features.${feature} = {
    enable = mkEnableOption "Core replacements" // {default = true;};
  };

  config = mkIf (attrByPath [ "features" feature "enable" ] false config) {
    programs.eza = {
      enable = true;
    };
  };
}
