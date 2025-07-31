{
  description = "QuantDash Haskell backend";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskellPackages;
        quantdash = haskellPackages.callCabal2nix "quantdash-hs" ./. { };
      in
      {
        packages.default = quantdash;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            haskellPackages.cabal-install
            haskellPackages.ghc
            haskellPackages.hlint
            haskellPackages.ormolu
            zlib
            # add others like sqlite/postgresql here if needed
          ];
          shellHook = ''
            echo "Welcome to the QuantDash dev shell!"
          '';
        };
      });
}

