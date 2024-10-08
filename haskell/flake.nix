{
  description = "Haskell + GTK Project Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";  # Reference a specific nixpkgs version
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      ghc = pkgs.haskellPackages.ghc;
      cabal = pkgs.haskellPackages.cabal-install;
      gtk = pkgs.gtk3;
    in
    {
      # Dev shell to be used with `nix develop`
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.gobject-introspection  # GObject Introspection
          pkgs.gtk3                  # GTK3
          pkgs.haskellPackages.ghc
          pkgs.haskellPackages.cabal-install
          pkgs.haskellPackages.gtk3
          pkgs.pcre2
          pkgs.pkg-config        # pkg-config for GTK
          pkgs.glib              # GLib for GTK dependencies
          pkgs.haskellPackages.c2hs              # C2HS for GTK Haskell bindings
          pkgs.gtk3.dev          # GTK development headers
          pkgs.xorg.libXdmcp
        ];

        shellHook = ''
          echo "Welcome to your Haskell + GTK development environment!"
          echo "Run 'cabal build' to build your project."
        '';
      };

      # Default package (optional: if you want a build output)
      defaultPackage = pkgs.haskellPackages.callCabal2nix "my-haskell-gtk-project" ./. {};
    });
}
