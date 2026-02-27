# Gaming configuration
# Import this from hosts that are gaming machines

{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.zwift.nixosModules.zwift
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # CachyOS kernel overlay and binary cache
  # Mesa 25.3.4 overlay — pin mesa to test for regression in 26.0.0
  # Remove the mesa overlay once testing is complete
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    (final: prev: let
      mesaPinned = inputs.nixpkgs-mesa-pinned.legacyPackages.${final.stdenv.hostPlatform.system};
    in {
      mesa = mesaPinned.mesa;
    })
  ];
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  # CachyOS kernel (BORE scheduler, AMD patches, sched_ext, ThinLTO)
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  # Temporarily using 6.12 LTS to test amdgpu regression
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Valve's LAVD scheduler via sched_ext (latency-aware, designed for gaming)
  # Disabled while testing 6.12 LTS (sched_ext requires 6.17+)
  # services.scx = {
  #   enable = true;
  #   scheduler = "scx_lavd";
  # };

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
  # Note: capSysNice doesn't work inside Steam's bwrap sandbox (NixOS FHS limitation).
  # Process priority is handled by ananicy-cpp with cachyos rules instead.
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  # Zwift cycling app (runs in container)
  programs.zwift.enable = true;

  # Gaming packages
  environment.systemPackages = with pkgs; [
    discord
    furmark
    mangohud
    vulkan-tools
    lutris
    heroic
    bottles
    prismlauncher
    vkbasalt
  ];
}
