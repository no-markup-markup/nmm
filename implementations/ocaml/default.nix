{ pkgs ? import (
    builtins.fetchTarball
      "https://github.com/NixOS/nixpkgs/archive/refs/tags/26.05.tar.gz"
  ) { }
}:
pkgs.stdenv.mkDerivation {
  pname = "nmm-ocaml";
  version = "7";
  src = ./.;
  buildInputs = with pkgs; [
    ocaml
    ocamlPackages.findlib
    ocamlPackages.sedlex
    ocamlPackages.uuseg
    ocamlPackages.xml-light
  ];
  buildPhase = ''
    make bin/nmm-ocaml
    make share
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp bin/nmm-ocaml $out/bin/
    cp -r share $out/
  '';
}
