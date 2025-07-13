# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#   imports = [ ./disko-config.nix ];
#   disko.devices.disk.root.device = "/dev/sda";
#   disko.devices.disk.data1.device = "/dev/sdb";
#   disko.devices.disk.data2.device = "/dev/sdc";
# }
{disk ? "/dev/sda", ...}: {
  disko.devices = {
    disk.root = {
      type = "disk";
      device = disk;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "4G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          alpha = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "lvm_pv";
                vg = "vg1";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg1 = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "32G";
            content = {
              type = "swap";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"]; # Override existing partition
              subvolumes = let
                mountOptions = ["compress=zstd" "noatime"];
              in {
                "@" = {};
                "@/root" = {
                  mountpoint = "/";
                  inherit mountOptions;
                };
                "@/home" = {
                  mountpoint = "/home";
                  inherit mountOptions;
                };
                "@/nix" = {
                  mountpoint = "/nix";
                  inherit mountOptions;
                };
                "@/persist" = {
                  mountpoint = "/persist";
                  inherit mountOptions;
                };
                "@/var-lib" = {
                  mountpoint = "/var/lib";
                  inherit mountOptions;
                };
                "@/var-log" = {
                  mountpoint = "/var/log";
                  inherit mountOptions;
                };
                "@/var-tmp" = {
                  mountpoint = "/var/tmp";
                  inherit mountOptions;
                };
              };
            };
          };
        };
      };
    };
  };
}
