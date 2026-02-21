{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/system/desktop.nix
  ];

  # Lunar Lake requires a newer kernel for SOF audio topology ABI compatibility
  boot.kernelPackages = pkgs.linuxPackages_latest;

  myHost = {
    # Swap caps lock and escape
    kbOptions = "caps:swapescape";

    packages = [];
  };
}
