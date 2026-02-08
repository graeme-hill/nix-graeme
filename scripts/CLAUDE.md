# Scripts

These are the scripts that I intend to be available on every machine for managing the nix
configuration itself.

## switch

Run this to rebuild the whole system. If you add a package or something then run switch.

## homeswitch

Does a subset of what switch does. Use this if you change a dotfile/config file managed
by home manager. The only reason to run this is if you know your change doesn't add any
packages or anything and you want it to be faster than a full switch.

## packages

Just a shortcut to start editing the file that defines system packages in nvim.

## install-age-key

Helps you bootstrap sops-nix required key by loading from bitwarden. bw cli tool needs
to already be available. Will prompt you to either login or unlock your vault depending
on existing bitwarden status.


