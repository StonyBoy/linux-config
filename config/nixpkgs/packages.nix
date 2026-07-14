# Steen Hegelund
# Timestamp: 2026-Jun-08 13:43
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=nix :

# Installer: sh <(curl -L https://nixos.org/nix/install) --daemon
# Install packages: nix-env -irf ~/.config/nixpkgs/packages.nix
# See installed packages: nix-env -q --installed

{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
    # alacritty is not here: it is a GL/Wayland app and is locally built in
    # /usr/local/bin, like niri, so it uses the system Intel Mesa driver (no
    # nixGL). A nix build cannot find the system driver and fails EGL init.
    basic = [
        neovim
        fd
        ripgrep
        fzf
        git
        git-lfs       # provides the 'git lfs' subcommand via PATH
        delta         # git-delta: syntax-highlighting pager for git diffs
        bat           # cat clone with syntax highlighting
        gh
        tmux
        direnv
        gawk          # GNU awk; mawk on Ubuntu lacks features
        plantuml
        smatch
        (lib.lowPrio sparse)   # sparse + smatch both ship man1/semind.1.gz; let smatch win
    ];

    # niri and its Wayland UI tools (waybar, swaybg, swayidle, swaylock, mako,
    # satty, wayvnc) are locally built in /usr/local/bin, not from nix, so the
    # niri binary uses the system Intel Mesa driver (no nixGL) and swaylock uses
    # the system libpam. nwg-look stays on nix.
    ui = [
        nwg-look
    ];

    networking = [
        ethtool
        iproute2
        netsniff-ng
    ];
in
basic ++ ui ++ networking
