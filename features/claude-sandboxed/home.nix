{pkgs, ...}: {
  programs.claude-sandboxed = {
    enable = true;
    authProxy = "http://100.64.0.5:18080";
    authTokenFile = "./token";

    defaultModel = "claude-opus-4-7";
    defaultTheme = "light";

    copyGitOnInit = true;
    copyGitOnLaunch = false;

    permissive = true;

    ghTokenFile = "./gh-token";
  };
}
