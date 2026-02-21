{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/system/desktop.nix
  ];

  myHost = {
    # Swap caps lock and escape
    kbOptions = "caps:swapescape";
  };
}
