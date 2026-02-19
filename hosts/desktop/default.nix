{ config, pkgs, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    inputs.zwift.nixosModules.zwift
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Gaming-optimized kernel (zen has better scheduling and lower latency)
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # AMD P-State for better CPU scaling
  boot.kernelParams = [
    "amd_pstate=active"
  ];

  # Force performance governor for gaming
  powerManagement.cpuFreqGovernor = "performance";

  # ZRAM-specific sysctl (nix-gaming handles vm.max_map_count and split_lock)
  boot.kernel.sysctl = {
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

  # Controller/Steam hardware udev rules
  hardware.steam-hardware.enable = true;

  # Steam with extra compatibility and SteamOS-style platform optimizations
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    platformOptimizations.enable = true;
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Low-latency audio for gaming
  services.pipewire.lowLatency.enable = true;

  # GameMode (CPU governor optimization)
  programs.gamemode.enable = true;

  # Gamescope compositor for gaming (FSR, frame limiting, etc.)
  programs.gamescope = {
    enable = true;
    capSysNice = false;
    # args = [
    #   "--force-grab-cursor"
    # ];
  };

  # Zwift cycling app (runs in container)
  programs.zwift.enable = true;

  # AMD GPU shader precompilation optimizations
  environment.variables = {
    RADV_PERFTEST = "gpl,nggc";
  };

  myHost = {
    # Desktop monitor config
    monitorConfig = "monitor=,preferred,auto,1.25";
    # Keyboard already has caps/escape swapped in firmware
    kbOptions = "";

    packages = with pkgs; [
      discord
      furmark
      mangohud
      nvtopPackages.amd
      vulkan-tools
      obs-studio
      vlc
      bitwarden-desktop
      google-chrome
      protonup-qt
      lutris
      heroic
      bottles
      prismlauncher
      vkbasalt
    ];
  };
}
