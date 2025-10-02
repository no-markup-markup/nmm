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
          pkgs         = nixpkgs.legacyPackages.${system};
          pkgs_common  = [pkgs.bash pkgs.gnumake pkgs.xmldiff];
          pkgs_mercury = [pkgs.mercury];
          pkgs_rocq    = [pkgs.coq];
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
