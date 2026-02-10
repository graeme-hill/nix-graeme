{ config, pkgs, hostname, ... }:

{
  # Hostname from flake
  networking.hostName = hostname;

  # Networking
  networking.networkmanager.enable = true;

  # Firmware (required for WiFi, Bluetooth, etc.)
  hardware.enableRedistributableFirmware = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Timezone and locale
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Display manager and desktop
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  # XDG portal (needed for screen sharing, file pickers, etc.)
  xdg.portal = {
    enable = true;
    config.common.default = "hyprland";
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:swapescape";
  };

  # Printing
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Libvirt/KVM for virtual machines
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true; # TPM emulation for Windows 11
    };
  };
  programs.virt-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
