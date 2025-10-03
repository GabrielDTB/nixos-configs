{pkgs, ...}: {
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Videos/beets/fakey";
      library = "~/Videos/beets/musiclibrary2.db";
      import = {
        copy = false;
        move = false;
        write = false;
        languages = "en";
        incremental = true;
        incremental_skip_later = true;
        from_scratch = true;
      };
      plugins = [
        "fetchart"
        "embedart"
        "chroma"
        "duplicates"
      ];
    };
    package = with pkgs; (
      beets.override {
        pluginOverrides = {
          fetchart.enable = true;
        };
      }
    );
  };
}
