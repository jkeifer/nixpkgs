init-flake () {
    local dir envrc flake
    dir="${1-"."}"
    envrc="${dir}/.envrc"
    flake="${dir}/flake.nix"

    if [ -f "${envrc}" ]; then
        echo >&2 "skipping ${envrc}"
    else
        cat > "${dir}/.envrc" <<'EOF'
use flake
dotenv_if_exists .env
layout python
EOF
    fi

    if [ -f "${flake}" ]; then
        echo >&2 "skipping ${flake}"
    else
        cat > "${dir}/flake.nix" <<'EOF'
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = with pkgs; mkShell {
          buildInputs = [
            python312
          ];
        };
      }
    );
}
EOF
    fi

}
