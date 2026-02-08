{ config, pkgs, ... }:

{
  imports = [
    ../../hardware-configuration.nix
  ];

  # Host-specific overrides go here
  # Example: this host could disable docker and use podman instead:
  # virtualisation.docker.enable = false;
  # virtualisation.podman.enable = true;
}
