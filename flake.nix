{
  description = "Setup LazyVim using NixVim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    neovim-nightly.url = "github:neovim/neovim?dir=contrib";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins not available in nixpkgs
    huez-nvim = { url = "github:vague2k/huez.nvim"; flake = false; };
    blame-me-nvim = { url = "github:hougesen/blame-me.nvim"; flake = false; };
    cmake-tools-nvim = { url = "github:Civitasv/cmake-tools.nvim"; flake = false; };
    symbol-usage-nvim = { url = "github:Wansmer/symbol-usage.nvim"; flake = false; };
    cmake-gtest-nvim = { url = "github:hfn92/cmake-gtest.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      perSystem = { pkgs, lib, system, ... }:
        let
          # Derivation containing all plugins
          pluginPath = import ./plugins.nix { inherit pkgs lib inputs; };

          # Derivation containing all runtime dependencies
          runtimePath = (import ./runtime.nix { inherit pkgs; });

          # Link together all treesitter grammars into single derivation
          treesitterPath = pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
          };

          neovimNightly = inputs.neovim-nightly.packages.${system}.default;
          neovimWrapped = pkgs.wrapNeovim neovimNightly {
            configure = {
              customRC = /* vim */ ''
                " Populate paths to neovim
                let g:config_path = "${./config}"
                let g:plugin_path = "${pluginPath}"
                let g:runtime_path = "${runtimePath}"
                let g:treesitter_path = "${treesitterPath}"
                " Begin initialization
                source ${./config/init.lua}
              '';
              packages.all.start = [ pkgs.vimPlugins.lazy-nvim ];
            };
          };
        in
        {
          packages = rec {
            nvim = pkgs.writeShellApplication {
              name = "nvim";
              runtimeInputs = [ runtimePath ];
              text = ''${neovimWrapped}/bin/nvim "$@"'';
            };
            default = nvim;
          };
        };
    };
}
