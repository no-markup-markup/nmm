{
  description = "no-markup-markup";

  inputs = {
    pins.url                 = "github:anderslundstedt/nix-pins";
    nixpkgs-unstable.follows = "pins/nixpkgs-unstable";
    flake-utils.follows      = "pins/flake-utils";
  };
  outputs = inputs@{self,...}:
    let
      linux-systems  = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      darwin-systems = [
        "aarch64-darwin"
      ];
      ## windows-systems = [
      ##   # TODO "x86_64-windows"
      ## ];
      systems = linux-systems ++ darwin-systems; ## TODO ++ windows-systems;
      version = "0";
    in
      inputs.flake-utils.lib.eachSystem systems (system:
        let
          pkgs-25-11    =
            inputs.pins.nixpkgs-25-11.${system}.legacyPackages.${system};
          pkgs-stable   =
            inputs.pins.nixpkgs-stable.${system}.legacyPackages.${system};
          pkgs-unstable =
            inputs.nixpkgs-unstable.legacyPackages.${system};
          # next up the nix-auto-follow package
          # we need to patch it
          # why? see:
          # https://claude.ai/share/878a571e-2bc3-4af6-bf93-1570121e47d7
          # short version:
          # we need to strip propagatedBuildInputs since nixpkgs' python build
          # infra always propagates the bare interpreter for
          # buildPythonApplication derivations, and this one's interpreter (from
          # nix-auto-follow's own pinned nixpkgs) would otherwise shadow
          # python-env on PATH, breaking `import typer` with no error at eval
          # time. safe to drop: nix-auto-follow has no python dependencies of
          # its own
          pkg-nix-auto-follow-unpatched =
            inputs.pins.nix-auto-follow.${system}.packages.${system}.default;
          pkg-nix-auto-follow-patched   =
            pkg-nix-auto-follow-unpatched.overrideAttrs (_: {
              propagatedBuildInputs = [];
            });
          python-env          = is-dev-shell: (
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
          pkgs_common = is-dev-shell: [
            pkg-nix-auto-follow-patched
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
