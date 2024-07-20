nix-cage
--------------

[![Build Status](https://travis-ci.org/corpix/nix-cage.svg?branch=master)](https://travis-ci.org/corpix/nix-cage)

Sandboxed environments with `bwrap` and `nix` package manager.

## Requirements

- Python
- Bubblewrap
- Nix

## Basics

For basic usage there are 2 steps:

- create `flake.nix` with settings you need
- start `nix-cage`

Example of `flake.nix`:

```nix
{
  description = "Generic devShell";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: (forSystem system f));
      forSystem = system: f: f rec {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
        };
        lib = pkgs.lib;
      };
    in {
      devShells = forAllSystems ({ system, pkgs, ... }: {
        default = nixpkgs.legacyPackages.${system}.stdenvNoCC.mkDerivation {
          name = "nix-shell";
          buildInputs = with pkgs; [
            python3
          ];
          NIX_PATH="nixpkgs=${nixpkgs}";
          LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
          LANG = "en_US.utf8";
          shellHook = ''
            cd ~
          '';
        };
      });
    };
}
```

Now start `nix-cage`:

```console
$ nix-cage
bwrap --ro-bind / / --dev-bind /dev /dev ...

[user@localhost:~/projects/src/github.com/corpix/nix-cage]$ cat nix-cage.json
{
    "mounts": {"rw": ["~/.emacs.d"]}
}
```

Each time you start `nix-cage` it will print `bwrap` command which you could use to get the same result while running it manually or for debug. After that the `nix-shell` will be started.

## License

[Unlicense](https://unlicense.org/)
