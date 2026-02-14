{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  myHost = {
    # Desktop monitor config
    monitorConfig = "monitor=,preferred,auto,1.25";
    # Keyboard already has caps/escape swapped in firmware
    kbOptions = "";

    packages = with pkgs; [
      steam
      discord
    ];
  };
}
