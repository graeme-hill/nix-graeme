{ config, pkgs, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/system/desktop.nix
    ../../modules/system/gaming.nix
  ];


  # AMD P-State for better CPU scaling
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.runpm=0"       # Disable dGPU runtime PM (prevents dual-GPU power cycling crashes)
    "amdgpu.gfx_off=0"    # Disable GFX power gating
    "amdgpu.gpu_recovery=0" # Disable GPU reset (prevents kernel crash on failed recovery)
  ];

  # AMD GPU specific settings
  hardware.amdgpu.initrd.enable = true;  # Early KMS
  environment.variables = {
    RADV_PERFTEST = "gpl,nggc";
  };

  myHost = {
    # Desktop monitor config
    monitorConfig = "monitor=,preferred,auto,1.25";
    # Keyboard already has caps/escape swapped in firmware
    kbOptions = "";

    packages = with pkgs; [
      nvtopPackages.amd
    ];
  };
}
