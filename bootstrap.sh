#!/usr/bin/env bash
set -euo pipefail

# List available disks (excluding partitions, loop devices, etc.)
echo "Available disks:"
echo "----------------"
lsblk -d -p -n -o NAME,SIZE,MODEL | grep -E '^/dev/(sd|vd|nvme)' || true
echo "----------------"
echo

# Prompt for disk selection
read -p "Enter the disk to partition (e.g., /dev/sda): " DISK < /dev/tty

# Validate disk exists and is a block device
if [[ ! -b "$DISK" ]]; then
  echo "Error: $DISK is not a valid block device"
  exit 1
fi

# Check it's a whole disk, not a partition
if [[ "$DISK" =~ [0-9]$ ]] && [[ ! "$DISK" =~ nvme.*n[0-9]+$ ]]; then
  echo "Error: $DISK appears to be a partition, not a whole disk"
  exit 1
fi

# Show current disk info
echo
echo "Selected disk:"
lsblk "$DISK"
echo

# Stern warning
echo "!!! WARNING !!!"
echo "This will COMPLETELY ERASE all data on $DISK"
echo "This action is IRREVERSIBLE"
echo
read -p "Type 'yes' to confirm: " CONFIRM < /dev/tty

if [[ "$CONFIRM" != "yes" ]]; then
  echo "Cancelled."
  exit 1
fi

echo
echo "Partitioning $DISK..."

# Create GPT partition table
parted -s "$DISK" -- mklabel gpt

# Create EFI system partition (512MB)
parted -s "$DISK" -- mkpart ESP fat32 1MB 512MB
parted -s "$DISK" -- set 1 esp on

# Create root partition (rest of disk)
parted -s "$DISK" -- mkpart root ext4 512MB 100%

# Determine partition names (nvme uses p1, p2; others use 1, 2)
if [[ "$DISK" =~ nvme ]]; then
  PART1="${DISK}p1"
  PART2="${DISK}p2"
else
  PART1="${DISK}1"
  PART2="${DISK}2"
fi

echo "Formatting partitions..."

# Format EFI partition
mkfs.fat -F 32 -n boot "$PART1"

# Format root partition
mkfs.ext4 -L nixos "$PART2"

echo
echo "Mounting filesystems..."

# Mount root
mount "$PART2" /mnt

# Mount EFI
mkdir -p /mnt/boot
mount -o umask=0077 "$PART1" /mnt/boot

echo
echo "Disk layout:"
lsblk "$DISK"
echo

echo "Generating hardware configuration..."
nixos-generate-config --root /mnt

# Copy hardware config to live ISO's /etc/nixos so --impure can find it
mkdir -p /etc/nixos
cp /mnt/etc/nixos/hardware-configuration.nix /etc/nixos/

echo
echo "Available hosts: thinkpad, zenbook, desktop"
read -p "Enter hostname for this machine: " HOSTNAME < /dev/tty

if [[ -z "$HOSTNAME" ]]; then
  echo "Error: hostname cannot be empty"
  exit 1
fi

echo
echo "Installing NixOS with flake configuration '$HOSTNAME'..."
nixos-install --impure --flake github:graeme-hill/nix-graeme#"$HOSTNAME"

echo
echo "Setting password for user 'graeme'..."
nixos-enter --root /mnt -c "passwd graeme" < /dev/tty

echo
echo "Cloning nix-graeme repo..."
nixos-enter --root /mnt -c "su - graeme -c 'git clone https://github.com/graeme-hill/nix-graeme.git /home/graeme/nix-graeme'"

echo
echo "Installing age key for sops-nix secrets..."
echo "This will prompt you to log in to Bitwarden."
nixos-enter --root /mnt -c "su - graeme -c '/home/graeme/nix-graeme/scripts/install-age-key'" < /dev/tty

echo
echo "Done! You can now reboot into your new system."
echo "After reboot, secrets will be available and ~/nix-graeme is ready to use."
