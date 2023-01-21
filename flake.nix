{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        src = ./.;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ rustc cargo rustfmt rust-analyzer ed ];
        };

        packages = rec {
          bin = pkgs.rustPlatform.buildRustPackage {
            pname = "xn--ts9h";
            version = "0.1.2";

            inherit src;

            #cargoHash = pkgs.lib.fakeHash;
            cargoHash = "sha256-8zSGboy+awtcMj4Zojdv8giEnCiu5nyRxJLfr7ISS7I=";
          };

          default = pkgs.runCommand "xn--ts9h-files" { } ''
            mkdir -p $out/bin
            mkdir -p $out/share/man/man8
            mkdir -p $out/share/doc

            cp ${bin}/bin/xn--ts9h $out/bin/🥺
            cp ${src}/🥺.8 $out/share/man/man8
            cp ${src}/README.md $out/share/doc
            cp ${src}/LICENSE $out/share/doc
          '';
        };
      }) // {
        nixosModules.default = { pkgs, lib, config, ... }:
          with lib; {
            options.within.security.xn--ts9h = {
              enable = mkEnableOption "enable the best sudo replacement";
            };
            config = mkIf config.within.security.xn--ts9h.enable {
              security.wrappers."🥺" =
                let pkg = self.packages.${pkgs.system}.default;
                in {
                  source = "${pkg}/bin/🥺";
                  setuid = true;
                  setgid = true;
                  owner = "root";
                  group = "root";
                };
            };
          };

        checks.x86_64-linux = let pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in {
          basic = pkgs.nixosTest ({
            name = "basic-tests";
            nodes.default = { config, pkgs, ... }: {
              imports = [ self.nixosModules.default ];
              within.security.xn--ts9h.enable = true;
            };

            testScript = ''
              start_all()

              default.wait_for_unit("multi-user.target")
            '';
          });
        };
      };
}
