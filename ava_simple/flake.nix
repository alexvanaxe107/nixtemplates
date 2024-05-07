{
  description = "An over-engineered Hello World in bash";

  # Nixpkgs / NixOS version to use.
  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in

    {


      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
          with nixpkgsFor.${system};
        {
          # A sample package declaration 
          samplePackage = stdenv.mkDerivation rec {
              name = "sample-${version}";

              src = self;

              unpackPhase = ":";

              buildPhase =
                ''
                  cat > hello <<EOF
                  #! $SHELL
                  echo "Hello Nixers!"
                  EOF
                  chmod +x hello
                '';

              installPhase =
                ''
                  mkdir -p $out/bin
                  mkdir -p $out/configs/
                  mkdir -p $out/avatemplates/
                  cp -rf $src/src/configs/* $out/configs/
                '';
            };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.samplePackage);
    };
}
