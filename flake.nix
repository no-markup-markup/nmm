{
  description = "no-markup-markup";

  inputs = {
    nixpkgs.url     = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {self, nixpkgs, flake-utils}:
    let
      systems = [
        "aarch64-darwin"
        # TODO "aarch64-linux"
        "x86_64-darwin"
        # TODO "x86_64-linux"
        # TODO "x86_64-windows"
      ];
    in
      flake-utils.lib.eachSystem systems (system:
        let
          pkgs         = nixpkgs.legacyPackages.${system};
          pkgs_common  = [pkgs.bash pkgs.gnumake];
          pkgs_mercury = [pkgs.mercury];
          pkgs_rocq    = [pkgs.rocq-core_9_1];
          pkgs_ocaml   = []; # TODO
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
        }
      );
}
