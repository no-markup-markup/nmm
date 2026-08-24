{
  description = "no-markup-markup";

  inputs = {
    pins.url = "github:anderslundstedt/nix-pins";

    nixpkgs-linux-25-11.follows   = "pins/nixos-25-11";
    nixpkgs-darwin-25-11.follows  = "pins/nixpkgs-darwin-25-11";
    nixpkgs-linux-stable.follows  = "pins/nixos-stable";
    nixpkgs-darwin-stable.follows = "pins/nixpkgs-darwin-stable";
    nixpkgs-unstable.follows      = "pins/nixpkgs-unstable";

    flake-utils.url               = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs-linux-25-11,
    nixpkgs-darwin-25-11,
    nixpkgs-linux-stable,
    nixpkgs-darwin-stable,
    nixpkgs-unstable,
    flake-utils,
    ...
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
          pkgs-stable   = (
            if      builtins.elem system linux-systems  then
              nixpkgs-linux-stable.legacyPackages.${system}
            else if builtins.elem system darwin-systems then
              nixpkgs-darwin-stable.legacyPackages.${system}
            else
              nixpkgs-unstable.legacyPackages.${system}
          );
          pkgs-25-11    = (
            if      builtins.elem system linux-systems  then
              nixpkgs-linux-25-11.legacyPackages.${system}
            else if builtins.elem system darwin-systems then
              nixpkgs-darwin-25-11.legacyPackages.${system}
            else
              throw "Unsupported system: neither Linux nor Darwin"
          );
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          python-env    = is-dev-shell: (
            pkgs-stable.python313.withPackages (
              python-pkgs: (
                builtins.filter(x: x != 0) [
                  (if is-dev-shell then python-pkgs.ipython else 0)
                  python-pkgs.fonttools
                  python-pkgs.typer
                ]
              )
            )
          );
          pkgs_common   = is-dev-shell: [
            pkgs-stable.bash
            pkgs-stable.gnumake
            (python-env is-dev-shell)
            pkgs-25-11.python312Packages.weasyprint
            pkgs-stable.xmldiff
          ];
          pkgs_mercury  = [pkgs-stable.mercury];
          pkgs_rocq     = [pkgs-stable.coq];
          pkgs_ocaml    = [
            pkgs-unstable.ocaml
            pkgs-unstable.ocamlPackages.findlib
            pkgs-unstable.ocamlPackages.sedlex
            pkgs-unstable.ocamlPackages.uuseg
            pkgs-unstable.ocamlPackages.xml-light
          ];
          pkgs_github  = [pkgs-stable.gh pkgs-stable.gh-markdown-preview];
        in {
          devShells.default = pkgs-stable.mkShell {
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
          devShells.rocq = pkgs-stable.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_rocq;
          };
          devShells.mercury = pkgs-stable.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_mercury;
          };
          devShells.ocaml = pkgs-stable.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_ocaml;
          };
          devShells.github = pkgs-stable.mkShell {
            buildInputs = (pkgs_common true) ++ pkgs_github;
          };
          packages.default = pkgs-stable.stdenv.mkDerivation {
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
