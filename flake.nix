{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_25
            ];
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildNpmPackage {
            pname = "jsonata-lint";
            version = "1.0.0";
            src = ./.;
            npmDepsHash = "sha256-QC8YYxPoi6dRVgZc/5rSu/FW8jlTzhf+CIgVCfkOXLY=";
            dontNpmBuild = true;
          };
        }
      );
    };
}
