{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/system/desktop.nix
  ];

  myHost = {
    # Thinkpad monitor config
    monitorConfig = "monitor=,preferred,auto,1.5";
    # Swap caps lock and escape
    kbOptions = "caps:swapescape";
  };
}
