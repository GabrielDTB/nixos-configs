{...}: {
  users.users.gabe = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "disk" "render" "adbusers" "input"];
    uid = 1000;
  };
}
