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
