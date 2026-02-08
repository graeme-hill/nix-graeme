#!/usr/bin/env bash
set -euo pipefail

# List available disks (excluding partitions, loop devices, etc.)
echo "Available disks:"
echo "----------------"
lsblk -d -p -n -o NAME,SIZE,MODEL | grep -E '^/dev/(sd|vd|nvme)' || true
echo "----------------"
echo

# Prompt for disk selection
read -p "Enter the disk to partition (e.g., /dev/sda): " DISK

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
read -p "Type 'yes' to confirm: " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
  echo "Cancelled."
  exit 1
fi

echo
echo "Partitioning $DISK..."

# Create GPT partition table
parted "$DISK" -- mklabel gpt

# Create EFI system partition (512MB)
parted "$DISK" -- mkpart ESP fat32 1MB 512MB
parted "$DISK" -- set 1 esp on

# Create root partition (rest of disk)
parted "$DISK" -- mkpart root ext4 512MB 100%

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
mount "$PART1" /mnt/boot

echo
echo "Done! Disk layout:"
lsblk "$DISK"
echo
echo "Next steps:"
echo "  1. nixos-generate-config --root /mnt"
echo "  2. nixos-install --flake github:OWNER/nix-graeme#HOSTNAME"
