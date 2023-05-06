{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      packer-nvim dracula-nvim nvim-lspconfig
      nvim-dap impatient-nvim vim-numbertoggle
      lualine-nvim nvim-tree-lua harpoon
      presence-nvim fennel-vim vim-tmux-navigator
      trouble-nvim barbar-nvim telescope-nvim
      nvim-web-devicons plenary-nvim vim-closer
      vim-endwise
    ];
    extraLuaConfig = lib.fileContents ../nvim.lua;
    enable = true;
    defaultEditor = true;
  };
}
