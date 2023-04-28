{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      packer-nvim dracula-nvim nvim-lspconfig
      nvim-dap impatient-nvim
      vim-numbertoggle nvim-treesitter
      harpoon lualine-nvim vim-closer
      presence-nvim fennel-vim vim-tmux-navigator
      trouble-nvim barbar-nvim telescope-nvim
      nvim-tree-lua vim-tpipeline
    ];
    extraLuaConfig = lib.fileContents ../nvim.lua;
    enable = true;
    defaultEditor = true;
  };
}
