{
  inputs,
  outputs,
  lib,
}: {
  nixos = import ./nixos {inherit inputs outputs lib;};
  standalone = import ./standalone {inherit inputs outputs lib;};
}
