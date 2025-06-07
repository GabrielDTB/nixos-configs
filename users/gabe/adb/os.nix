{...}: {
  programs.adb.enable = true;
  users.users.gabe.extraGroups = ["adbusers"];
}
