{...}: {
  hardware.sane.enable = true;
  users.users.gabe.extraGroups = ["scanner"];
}
