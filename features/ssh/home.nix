{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      gbox.User = "gabe";
      glab.User = "gabe";
      gfrm.User = "gabe";
      slugbox = {
        HostName = "shitbox.stevens.institute";
        User = "gilberto";
        ServerAliveInterval = 30;
      };
    };
  };
}
