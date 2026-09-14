{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "nmm-ocaml";
  version = "0";
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
