{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    autoconf
    automake
    bubblewrap
    clang
    dnsutils
    emacs25-nox
    file
    fish
    gcc
    git
    glibcLocales
    gnumake
    graphviz-nox
    htop
    iotop
    iproute
    iputils
    libarchive
    lzma
    mc
    openssh
    p7zip
    procps
    python36Full
    python36Packages.ipython
    sshfs
    sshfs-fuse
    sudo
    tmux
    tree
    unzip
    v
    wget
    which
  ];
}
