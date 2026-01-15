{...}: {
  services.snapper = {
    configs = {
      RED = {
        ALLOW_USERS = ["gabe"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
        SUBVOLUME = "/home/gabe/Videos/qbittorrent/RED";
      };
      Enclave = {
        ALLOW_USERS = ["gabe"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
        SUBVOLUME = "/home/gabe/Enclave";
      };
    };
  };
}
