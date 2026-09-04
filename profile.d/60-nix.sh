#! /bin/bash
# -*-sh-*-
# Shell functions for common nix operations (see ~/Documents/specs/nix_on_ubuntu.md)

# Debugging
# set -x

function nixupdate()
{
    nix-channel --update
    nix-env -irf ~/.config/nixpkgs/packages.nix
}

function nixupdate-dryrun()
{
    nix-channel --update
    nix-env -irf ~/.config/nixpkgs/packages.nix --dry-run
}

function nixupgrade()
{
    nix-channel --update
    nix-env -u
}

function nixlist()
{
    nix-env -q --installed
}

function nixremove()
{
    nix-env -e "$1"
}

function nixgens()
{
    nix-env --list-generations
}

function nixdiff()
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: nixdiff <old-gen> <new-gen>"
        return 1
    fi
    nix store diff-closures --extra-experimental-features nix-command \
        ~/.local/state/nix/profiles/profile-"$1"-link \
        ~/.local/state/nix/profiles/profile-"$2"-link
}

function nixdiff-last()
{
    local gens
    gens=$(nix-env --list-generations | awk '{print $1}')
    local new old
    new=$(echo "$gens" | tail -1)
    old=$(echo "$gens" | tail -2 | head -1)
    nixdiff "$old" "$new"
}
