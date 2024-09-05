{
  description = "Atomic Pi NixOS modules and configurations";

  inputs = {
    nixpkgs = { url = "nixpkgs/nixos-unstable"; };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko }: {
    overlays.default = self: super: { };

    nixosConfigurations =
      let
        inherit (nixpkgs) lib;

        mkHost = hostname: rootModule: lib.nixosSystem {
          # The Atomic Pi is an x86_64 system.
          system = "x86_64-linux";

          specialArgs = {
            thisFlake = self;
            thisFlakeInputs = inputs;
          };

          modules = [
            {
              networking.hostName = lib.mkDefault hostname;

              # Set Nix path so that nix-shell and other tools can find the
              # currently-used nixpkgs revision.
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

              # command-not-found looks in channels by default for its database,
              # but since we are using nixpkgs as a flake, we don't have it.
              # So disable it.
              programs.command-not-found.enable = false;

              nixpkgs.overlays = lib.mapAttrsToList (name: overlay: overlay) self.overlays;
            }

            (import ./nixos/modules)
            (import ./nixos/profiles)

            disko.nixosModules.disko

            rootModule
          ];
        };

        # { <hostname> = "directory"; }
        hostDirectories =
          lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./nixos/hosts);

        # { <hostname> = <NixOS configuration>; }
        nixosConfigurations = lib.mapAttrs (hostname: _: mkHost hostname (import "${toString ./nixos/hosts}/${hostname}")) hostDirectories;
      in
      nixosConfigurations;
  };
}
