{
  lib,
  config,
  ...
}: {
  name,
  enableDefault ? false,
  body,
  ...
}:
with lib; {
  options.features.${name} = {
    enable = mkEnableOption name // {default = enableDefault;};
  };

  config = mkIf config.features.${name}.enable body;
}
