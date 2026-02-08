{ config, pkgs, ... }:

{
  users.users.graeme = {
    isNormalUser = true;
    description = "Graeme Hill";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
