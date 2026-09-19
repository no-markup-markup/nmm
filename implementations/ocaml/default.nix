{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  pname = "nmm-ocaml";
  version = "3";
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
