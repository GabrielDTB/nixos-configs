{
  pkgs,
  ...
}: {
  users.users.gabe = {
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
}
