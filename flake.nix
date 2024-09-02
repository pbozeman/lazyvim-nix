{
  description = "Setup LazyVim using NixVim";

  inputs = {
    nixpkgs = {
      # url = "github:NixOS/nixpkgs/nixos-unstable";
      #
      # Work around for treesitter build failure:
      #
      # Fails:
      # url = "github:NixOS/nixpkgs/8d8ab8cab";
      # Works: (as in treesitter compiles)
      # url = "github:NixOS/nixpkgs/77a4902508";
      #
      # but we still can't use it because of the is-not? issue
      # https://github.com/nvim-treesitter/nvim-treesitter/issues/6870
      url = "github:NixOS/nixpkgs/502b1ac291b58703a9c84a8c414c77fa88607ce6";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    # Plugins not available in nixpkgs
    blame-me-nvim = { url = "github:hougesen/blame-me.nvim"; flake = false; };
    cmake-tools-nvim = { url = "github:Civitasv/cmake-tools.nvim"; flake = false; };
    cmake-gtest-nvim = { url = "github:hfn92/cmake-gtest.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { pkgs, lib, system, ... }:
        let
          # Derivation containing all plugins
          pluginPath = import ./plugins.nix { inherit pkgs lib inputs; };

          # Derivation containing all runtime dependencies
          runtimePath = import ./runtime.nix { inherit pkgs; };

          # Link together all treesitter grammars into single derivation
          treesitterPath = pkgs.symlinkJoin {
            name = "lazyvim-nix-treesitter-parsers";
            paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
          };

          neovim = inputs.neovim.packages.${system}.default;
          # Wrap neovim with custom init and plugins
          neovimWrapped = pkgs.wrapNeovim neovim {
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
            # Wrap neovim again to make runtime dependencies available
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
