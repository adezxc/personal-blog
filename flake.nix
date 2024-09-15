# Inspired by https://github.com/jnsgruk/jnsgr.uk
{
  description = "adezxc's personal website and blog";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      pkgsForSystem = system: (import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (
        system:
        let
          inherit (pkgsForSystem system)
            buildEnv
            buildGo122Module
            cacert
            hugo
            lib
            ;
          version = self.shortRev or (builtins.substring 0 7 self.dirtyRev);
          rev = self.rev or self.dirtyRev;
        in
        {
          default = self.packages.${system}.adezxc;

          adezxc = buildGo122Module {
            inherit version;
            pname = "adezxc";
            src = lib.cleanSource ./.;

            vendorHash = "sha256-x4ROLEGyab2AJLLPANVrt2ywY84XFS1+4Bk1b4WypVk=";

            buildInputs = [ cacert ];
            nativeBuildInputs = [ hugo ];

            # Nix doesn't play well with Hugo's "GitInfo" module, so disable it and inject
            # the revision from the flake.
            postPatch = ''
              substituteInPlace ./site/layouts/shortcodes/gitinfo.html \
                --replace "{{ .Page.GitInfo.Hash }}" "${rev}" \
                --replace "{{ .Page.GitInfo.AbbreviatedHash }}" "${version}"

              substituteInPlace ./site/config/_default/config.yaml \
                --replace "enableGitInfo: true" "enableGitInfo: false"
            '';

            # Generate the Hugo site before building the Go application which embeds the
            # built site.
            preBuild = ''
              go generate ./...
            '';

            ldflags = [ "-X main.commit=${rev}" ];

            # Rename the main executable in the output directory
            #postInstall = ''
            #  mv $out/bin/jnsgr.uk $out/bin/adezxc
            #'';

            meta.mainProgram = "adezxc";
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsForSystem system;
        in
        {
          default = pkgs.mkShell {
            name = "adezxc";
            NIX_CONFIG = "experimental-features = nix-command flakes";
            nativeBuildInputs = with pkgs; [
              go_1_21
              go-tools
              gofumpt
              gopls
              hugo
              zsh
            ];
            shellHook = "exec zsh";
          };
        }
      );
    };
}
