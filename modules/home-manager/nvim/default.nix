{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
in {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      nvim-lspconfig
      nvim-dap
      impatient-nvim
      vim-numbertoggle
      lualine-nvim
      nvim-tree-lua
      harpoon
      presence-nvim
      fennel-vim
      vim-tmux-navigator
      trouble-nvim
      barbar-nvim
      telescope-nvim
      nvim-web-devicons
      plenary-nvim
      vim-closer
      vim-endwise
      moonscript-vim
      {
        plugin = vimThemeFromScheme { scheme = config.colorScheme; };
        config = "colorscheme nix-${config.colorScheme.slug}";
      }
    ];
    extraLuaConfig = ''
      ${lib.fileContents ./nvim.lua}
    '';
    enable = true;
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    wget
    unzip
    tree-sitter
  ];
  xdg.desktopEntries = {
    neovide = {
      name = "Neovide";
      exec = "env -u WAYLAND_DISPLAY neovide";
      terminal = false;
      categories = [ "Utility" "TextEditor" ];
    };
  };
}
