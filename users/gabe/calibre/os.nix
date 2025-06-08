{
  ...
}: {
  services.calibre-web = {
    enable = true;
    options = {
      enableBookUploading = true;
      enableBookConversion = true;
      enableKepubify = true;
    };
  };
}
