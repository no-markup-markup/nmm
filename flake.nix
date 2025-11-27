{
  description = "no-markup-markup";

  inputs = {
    nixpkgs-linux.url    = "nixpkgs/nixos-25.05";
    nixpkgs-darwin.url   = "nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url      = "github:numtide/flake-utils";
  };
  outputs = {
    self, nixpkgs-linux, nixpkgs-darwin, nixpkgs-unstable, flake-utils
  }:
    let
      linux-systems  = [
        # TODO "aarch64-linux"
        "x86_64-linux"
      ];
      darwin-systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      ## windows-systems = [
      ##   # TODO "x86_64-windows"
      ## ];
      systems = linux-systems ++ darwin-systems; ## TODO ++ windows-systems;
      version = "0";
    in
      flake-utils.lib.eachSystem systems (system:
        let
          nixpkgs      = (
            if      builtins.elem system linux-systems  then
              nixpkgs-linux
            else if builtins.elem system darwin-systems then
              nixpkgs-darwin
            else
              nixpkgs-unstable
          );
          pkgs          = nixpkgs.legacyPackages.${system};
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          pkgs_common   = [
            pkgs.bash
            pkgs.gnumake
            pkgs.python313
            pkgs-unstable.python313Packages.weasyprint
            pkgs.xmldiff
          ];
          pkgs_mercury  = [pkgs.mercury];
          pkgs_rocq     = [pkgs.coq];
          pkgs_ocaml    = [
            pkgs-unstable.ocaml
            pkgs-unstable.ocamlPackages.findlib
            pkgs-unstable.ocamlPackages.menhir
            pkgs-unstable.ocamlPackages.menhirLib
            pkgs-unstable.ocamlPackages.sedlex
            pkgs-unstable.ocamlPackages.uuseg
            pkgs-unstable.ocamlPackages.xml-light
          ];
          pkgs_github  = [pkgs.gh pkgs.gh-markdown-preview];
        in {
          devShells.default = pkgs.mkShell {
            buildInputs = (
              pkgs_common
              ++
              pkgs_mercury
              ++
              pkgs_rocq
              ++
              pkgs_ocaml
              ++
              pkgs_github
            );
          };
          devShells.rocq = pkgs.mkShell {
            buildInputs = pkgs_common ++ pkgs_rocq;
          };
          devShells.mercury = pkgs.mkShell {
            buildInputs = pkgs_common ++ pkgs_mercury;
          };
          devShells.ocaml = pkgs.mkShell {
            buildInputs = pkgs_common ++ pkgs_ocaml;
          };
          devShells.github = pkgs.mkShell {
            buildInputs = pkgs_common ++ pkgs_github;
          };
          packages.default = pkgs.stdenv.mkDerivation {
            name        = "no-markup-markup-${version}";
            buildInputs = (
              [pkgs.makeWrapper]
              ++
              pkgs_common
              ++
              pkgs_mercury
              ++
              pkgs_ocaml
            );
            src          = ./.;
            buildPhase   = ''
              make bin
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp bin/* $out/bin/
            '';
          };
          apps.default = {
            type    = "app";
            program = "${self.packages.${system}.default}/bin/nmm";
          };
        }
      );
}
