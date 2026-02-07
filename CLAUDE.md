# Graeme's NixOS Flake

This repo is a nix configuration defined as a flake that can be used to initialize
a machine in the way I want it. Nearly everything about the system should be defined in
here and to make any changes you edit it in this repo, then run the `switch` command
(from the scripts/ subdirectory).

System packages, network config, and dotfiles (via home manager) are all controlled from
here.
