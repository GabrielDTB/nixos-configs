{pkgs, ...}: {
  users.users.gabe = {
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
}
