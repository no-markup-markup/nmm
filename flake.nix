{
  description = "no-markup-markup";

  inputs = {
    nixos-25-11.url          = "nixpkgs/nixos-25.11";
    nixpkgs-darwin-25-11.url = "nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-linux.url        = "nixpkgs/nixos-26.05";
    nixpkgs-darwin.url       = "nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url     = "nixpkgs/nixpkgs-unstable";
    flake-utils.url          = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixos-25-11,
    nixpkgs-darwin-25-11,
    nixpkgs-linux,
    nixpkgs-darwin,
    nixpkgs-unstable,
    flake-utils
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
          pkgs          = (
            if      builtins.elem system linux-systems  then
              nixpkgs-linux.legacyPackages.${system}
            else if builtins.elem system darwin-systems then
              nixpkgs-darwin.legacyPackages.${system}
            else
              nixpkgs-unstable.legacyPackages.${system}
          );
          pkgs-25-11    = (
            if      builtins.elem system linux-systems  then
              nixos-25-11.legacyPackages.${system}
            else if builtins.elem system darwin-systems then
              nixpkgs-darwin-25-11.legacyPackages.${system}
            else
              nixos-25-11.legacyPackages.${system}
          );
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          python-env    = is-dev-shell: (
            pkgs.python313.withPackages (
              python-pkgs: (
                builtins.filter(x: x != 0) [
                  (if is-dev-shell then python-pkgs.ipython else 0)
                  python-pkgs.typer
                ]
              )
            )
          );
          pkgs_common   = is-dev-shell: [
            pkgs.bash
            pkgs.gnumake
            (python-env is-dev-shell)
            pkgs-25-11.python312Packages.weasyprint
            pkgs.xmldiff
          ];
          pkgs_mercury  = [pkgs.mercury];
          pkgs_rocq     = [pkgs.coq];
          pkgs_ocaml    = [
            pkgs-unstable.ocaml
            pkgs-unstable.ocamlPackages.findlib
            pkgs-unstable.ocamlPackages.sedlex
            pkgs-unstable.ocamlPackages.uuseg
            pkgs-unstable.ocamlPackages.xml-light
          ];
          pkgs_github  = [pkgs.gh pkgs.gh-markdown-preview];
        in {
          devShells.default = pkgs.mkShell {
            buildInputs = (
              (pkgs_common true)
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
            buildInputs = (pkgs_common true) ++ pkgs_rocq;
          };
          devShells.mercury = pkgs.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_mercury;
          };
          devShells.ocaml = pkgs.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_ocaml;
          };
          devShells.github = pkgs.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_github;
          };
          packages.default = pkgs.stdenv.mkDerivation {
            name        = "no-markup-markup-${version}";
            buildInputs = (
              (pkgs_common false)
              ++
              pkgs_mercury
              ++
              pkgs_ocaml
            );
            src          = ./.;
            patchPhase   = ''
              patchShebangs bin/nmm
            '';
            buildPhase   = ''
              make bin
              make share
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp bin/* $out/bin/
              rm       $out/bin/Makefile
              mkdir -p $out/share
              cp -r share/* $out/share/
            '';
          };
          apps.default = {
            type    = "app";
            program = "${self.packages.${system}.default}/bin/nmm";
          };
        }
      );
}
