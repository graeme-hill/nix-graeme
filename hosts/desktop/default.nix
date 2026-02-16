{ config, pkgs, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.zwift.nixosModules.zwift
  ];

  # Gaming-optimized kernel (xanmod has better scheduling and lower latency)
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Gaming kernel/memory optimizations (Bazzite-style)
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;  # Bazzite default, needed for many Proton games
    "vm.swappiness" = 180;            # Higher for zram
    "vm.page-cluster" = 0;            # Better for zram random access
    "vm.compaction_proactiveness" = 0; # Reduce latency spikes
  };

  # ZRAM swap (Bazzite uses this instead of disk swap)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Process priority management for gaming
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # GPU acceleration with 32-bit support (needed for most games)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD GPU specific settings
  hardware.amdgpu.initrd.enable = true;  # Early KMS

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
