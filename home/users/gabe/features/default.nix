{...}: {
  imports = [
    ./helix
    ./firefox
  ];
  programs.git = {
    enable = true;
    userName = "Gabriel Talbert Bunt";
    userEmail = "gabriel@gabrieltb.me";
  };
}
