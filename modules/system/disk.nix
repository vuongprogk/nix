{ config, pkgs, ... }:

{
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/01DB1190A28A5860";
    fsType = "ntfs";
    options = [ "defaults" ];
  };
}
