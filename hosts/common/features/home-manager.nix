{
  inputs,
  outputs,
  mkFeature,
  ...
}:
mkFeature {
  name = "home-manager";
  body = {
    home-manager = {
      extraSpecialArgs = {inherit inputs outputs;};
    };
  };
}
