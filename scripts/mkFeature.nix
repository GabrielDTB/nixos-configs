{
  lib,
  config,
  ...
}: {
  name,
  enableDefault ? false,
  body,
  options ? {},
  ...
}:
with lib; {
  options.features.${name} =
    {
      enable = mkEnableOption name // {default = enableDefault;};
    }
    // options;

  config = mkIf config.features.${name}.enable body;
}
