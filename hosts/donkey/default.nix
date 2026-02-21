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
    "amdgpu.runpm=0"    # Disable dGPU runtime PM (prevents dual-GPU power cycling crashes)
    "amdgpu.gfx_off=0"  # Disable GFX power gating
  ];

  # AMD GPU specific settings
  hardware.amdgpu.initrd.enable = true;  # Early KMS
  environment.variables = {
    RADV_PERFTEST = "gpl,nggc";
  };

  myHost = {
    # Keyboard already has caps/escape swapped in firmware
    kbOptions = "";

    packages = with pkgs; [
      nvtopPackages.amd
    ];
  };
}
