{
  description = "LLM-from-scratch dev env";

  inputs.nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs;
            [
              python311
              virtualenv
            ] ++ (with pkgs.python311Packages;
              [
                pip
                torchaudio
                torchvision
                torch
              ]);

          shellHooks = ''
                     echo "Welcome to the llm-from-scratch dev environment!"
          '';
        };
      });
  };
}
