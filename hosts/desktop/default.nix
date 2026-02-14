{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  # GPU acceleration (required for Steam/gaming)
  hardware.graphics.enable = true;

  # Steam with proper FHS environment
  programs.steam.enable = true;

  # Gamescope compositor for gaming (FSR, frame limiting, etc.)
  programs.gamescope.enable = true;

  myHost = {
    # Desktop monitor config
    monitorConfig = "monitor=,preferred,auto,1.25";
    # Keyboard already has caps/escape swapped in firmware
    kbOptions = "";

    packages = with pkgs; [
      discord
    ];
  };
}
