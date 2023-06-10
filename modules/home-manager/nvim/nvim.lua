vim.cmd [[packadd packer.nvim]]

require("impatient")

vim.opt.nu = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.g.mapleader = " "

vim.cmd("set cb=unnamedplus")

local function setKeys(keys)
    for k, v in pairs(keys) do
        vim.keymap.set("n", k, v)
    end
end

require("bufferline").setup {
  animation = true,
  auto_hide = true,
  tabpages = true,
  clickable = false,
}

do
  local keys = {
    ["<A-,>"] = ":BufferPrevious<CR>",
    ["<A-.>"] = ":BufferNext<CR>",
    ["<A-w>"] = ":BufferClose<CR>",
    ["<A-c>"] = ":BufferClose<CR>",
    ["<C-w>h"] = ":split<CR>",
    ["<A-Enter>"] = function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end,
  }
  
  setKeys(keys)
end

do
  local mark = require("harpoon.mark")
  local ui = require("harpoon.ui")

  local set = vim.keymap.set

  set("n", "<C-a>", function() mark.add_file() end)
  set("n", "<C-s>", function() ui.toggle_quick_menu() end)
  set("n", "<A-1>", function() ui.nav_file(1) end)
  set("n", "<A-2>", function() ui.nav_file(2) end)
  set("n", "<A-3>", function() ui.nav_file(3) end)
  set("n", "<A-4>", function() ui.nav_file(4) end)
end

do
  local lsp = require("lsp-zero")

  lsp.preset("recommended")

  lsp.ensure_installed({ "rust_analyzer" })

  local cmp = require('cmp')
  local cmp_select = { behavior = cmp.SelectBehavior.Select }
  local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
  })

  lsp.set_preferences({
    sign_icons = {}
  })

  lsp.setup_nvim_cmp({
    mapping = cmp_mappings
  })

  lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<C-f>", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("i", "<C-f>", function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end)

  lsp.setup()
end

do
  local function icon()
    return " "
  end

  require("lualine").setup {
    globalstatus = true,
    extensions = {
      "nvim-tree",
      "quickfix",
      "symbols-outline"
    },

    ignore_focus = {
      "NvimTree"
    },

    sections = {
      lualine_a = { icon },
      lualine_c = {},
      lualine_x = { "filename" }
    },

    inactive_sections = {
      lualine_a = { icon },
      lualine_c = {},
      lualine_x = { "filename" }
    }
  }
end

require("mason").setup()

do
  local pres = require("presence")
  local files = require("presence.file_assets")

  for k, v in pairs(files) do
    files[k][2] = "https://github.com/notvirtio/nvim/raw/master/nixie.png"
  end

  pres.setup{
      auto_update = true,
      main_image = "file",
      file_assets = files,
      buttons = {
        {
          label = "uwu",
          url = "https://discord.gg/vzq5StnSjf"
        }
      }
  }
end

do
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")
  local ivy = themes.get_ivy({})
  local diag = themes.get_ivy({})
  diag.bufnr = 0

  vim.keymap.set("n", "<leader>ff", function() builtin.find_files(ivy) end, {})
  vim.keymap.set("n", "<leader>fg", function() builtin.live_grep(ivy) end, {})
  vim.keymap.set("n", "<leader>fd", function() builtin.diagnostics(diag) end, {})
end

do
  vim.g.tmux_navigator_no_mappings = 1

  local keys = {
        ["<C-h>"] = ":<C-U>TmuxNavigateLeft<CR>",
        ["<C-j>"] = ":<C-U>TmuxNavigateDown<CR>",
        ["<C-k>"] = ":<C-U>TmuxNavigateUp<CR>",
        ["<C-l>"] = ":<C-U>TmuxNavigateRight<CR>",
  }

  setKeys(keys)
end

do
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.opt.termguicolors = true

  require("nvim-tree").setup {
      sort_by = "case_sensetive"
  }

  vim.keymap.set("n", "<leader>v", function() vim.cmd("NvimTreeToggle") end)
end

do
  require("nvim-treesitter.configs").setup {
      ensure_installed = {"rust"},
      sync_install = false,
      auto_install = true,

      highlight = {
          enable = true
      }
  }
end

require("trouble").setup{}

require("packer").startup(function(use)
  use "pigpigyyy/Yuescript-vim"
  use "nvim-treesitter/nvim-treesitter"

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' },

      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }
end)
