{ config, pkgs, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.zwift.nixosModules.zwift
  ];

  # GPU acceleration with 32-bit support (needed for most games)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD GPU specific settings
  hardware.amdgpu = {
    initrd.enable = true;  # Early KMS
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  # Steam with extra compatibility
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # GameMode (CPU governor optimization)
  programs.gamemode.enable = true;

  # Gamescope compositor for gaming (FSR, frame limiting, etc.)
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Zwift cycling app (runs in container)
  programs.zwift.enable = true;

  myHost = {
    # Desktop monitor config
    monitorConfig = "monitor=,preferred,auto,1.25";
    # Keyboard already has caps/escape swapped in firmware
    kbOptions = "";

    packages = with pkgs; [
      discord
      mangohud
      vulkan-tools
    ];
  };
}
