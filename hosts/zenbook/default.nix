{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  myHost = {
    # Zenbook monitor config
    monitorConfig = "monitor=,preferred,auto,1.5";
    # Swap caps lock and escape
    kbOptions = "caps:swapescape";
  };
}
