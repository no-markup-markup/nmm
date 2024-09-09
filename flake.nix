{
  description = "no-markup-markup";

  inputs = {
    nixpkgs.url     = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {self, nixpkgs, flake-utils}:
    let
      systems = [
        # TODO "aarch64-darwin"
        # TODO "aarch64-linux"
        "x86_64-darwin"
        # TODO "x86_64-linux"
        # TODO "x86_64-windows"
      ];
    in
      flake-utils.lib.eachSystem systems (system:
        let
          pkgs         = nixpkgs.legacyPackages.${system};
          pkgs_common  = []; # TODO
          pkgs_mercury = [pkgs.mercury];
          pkgs_ocaml   = []; # TODO
          pkgs_github  = []; # TODO
        in {
          devShells.default = pkgs.mkShell {
            buildInputs =
              pkgs_common ++ pkgs_mercury ++ pkgs_ocaml ++ pkgs_github;
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
