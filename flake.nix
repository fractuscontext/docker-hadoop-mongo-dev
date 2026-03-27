{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # --- VS Code Background Tools ---
            nixd # Language Server for Nix
            nixfmt # Formatter for Nix
            shfmt # Formatter for Shell scripts
            shellcheck # Linter for Shell scripts

            # --- Linters ---
            ruff # Python
            hadolint # Dockerfile
            yamllint # YAML

            # --- Infra ---
            podman-compose
            podman
          ];

          shellHook = ''
            echo "🐘 Welcome to the Hadoop/Mongo Cluster Dev Shell 🍃"
            echo "Tools available: ruff (Python), hadolint (Docker), yamllint (YAML)"
          '';
        };
      }
    );
}
