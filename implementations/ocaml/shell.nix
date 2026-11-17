{ pkgs ? import <nixpkgs> { }, ... }:

let
  build_pkgs = with pkgs; [
    ocaml
    ocamlPackages.findlib
    ocamlPackages.sedlex
    ocamlPackages.uuseg
    ocamlPackages.xml-light
  ];

  dev_pkgs = with pkgs; [
    ocamlPackages.utop
    ocamlformat
  ];
in

pkgs.mkShell {

  packages = build_pkgs ++ dev_pkgs;

  shellHook = ''
    echo "Welcome to the developer shell for nmm-ocaml!"
    export PS1="(dev-shell) $PS1"
  '';

}
