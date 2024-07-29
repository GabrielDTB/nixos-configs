{
  lib,
  ...
}:
{
  name,
  description,
  enableDefault,
  body,
  ...
}: with lib; {
  options.features.${name} = {
    enable = mkEnableOption description // {default = enableDefault;};
  };

  config = mkIf (attrByPath [ "features" name "enable "] false config) body;
}
