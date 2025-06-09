{pkgs, ...}: {
  services.calibre-web = {
    enable = true;
    package = pkgs.calibre-web.overridePythonAttrs (old: {
      dependencies = with old.optional-dependencies;
        old.dependencies ++ kobo ++ metadata ++ comics;
    });
    options = {
      enableBookUploading = true;
      enableBookConversion = true;
      enableKepubify = true;
    };
    listen.ip = "0.0.0.0";
    openFirewall = true;
  };
}
