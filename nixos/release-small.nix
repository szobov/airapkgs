# This jobset is used to generate a NixOS channel that contains a
# small subset of Nixpkgs, mostly useful for servers that need fast
# security updates.

{ nixpkgs ? { outPath = (import ../lib).cleanSource ./..; revCount = 56789; shortRev = "gfedcba"; }
, stableBranch ? false
, supportedSystems ? [ "x86_64-linux" ] # no i686-linux
}:

let

  nixpkgsSrc = nixpkgs; # urgh

  pkgs = import ./.. {};

  lib = pkgs.lib;

  nixos' = import ./release.nix {
    inherit stableBranch supportedSystems;
    nixpkgs = nixpkgsSrc;
  };

  nixpkgs' = builtins.removeAttrs (import ../pkgs/top-level/release.nix {
    inherit supportedSystems;
    nixpkgs = nixpkgsSrc;
  }) [ "unstable" ];

in rec {

  nixos = {
    inherit (nixos') channel manual iso_minimal docker_image dummy;
    tests = {
      inherit (nixos'.tests)
        containers-imperative
        containers-ipv4
        firewall
        ipv6
        login
        misc
        nat
        nfs3
        openssh
        php-pcre
        predictable-interface-names
        proxy
        simple;
      installer = {
        inherit (nixos'.tests.installer)
          lvm
          separateBoot
          simple;
      };
      boot = {
        inherit (nixos'.tests.boot)
          biosCdrom;
      };
    };
  };

  nixpkgs = {
    inherit (nixpkgs')
      apacheHttpd
      cmake
      cryptsetup
      emacs
      gettext
      git
      imagemagick
      jdk
      linux
      mysql
      nginx
      nodejs
      openssh
      php
      postgresql
      python
      rsyslog
      stdenv
      subversion
      tarball
      vim
      parity-beta
      parity
      solc
      robonomics_dev
      robonomics_comm
      robonomics_game
      aira-quick-start;
  };

  tested = lib.hydraJob (pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.channel.version}";
    meta = {
      description = "Release-critical builds for the NixOS channel";
      maintainers = [ lib.maintainers.akru ];
    };
    constituents =
      let all = x: map (system: x.${system}) supportedSystems; in
      [ nixpkgs.tarball
        (all nixpkgs.aira-quick-start)
        (all nixpkgs.robonomics_dev)
        (all nixpkgs.robonomics_comm)
        (all nixpkgs.robonomics_game)
        (all nixpkgs.parity-beta)
        (all nixpkgs.parity)
      ]
      ++ lib.collect lib.isDerivation nixos;
  });

}
