-- local require = require("lvim.utils.require").require
local core_plugins = {
  { url = "https://e.coding.net/zydou/vim/lazy.nvim.git", tag = "stable" },
  {
    url = "https://e.coding.net/zydou/vim/nvim-lspconfig.git",
    lazy = true,
    dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
  },
  {
    url = "https://e.coding.net/zydou/vim/mason-lspconfig.nvim.git",
    cmd = { "LspInstall", "LspUninstall" },
    config = function()
      require("mason-lspconfig").setup(lvim.lsp.installer.setup)

      -- automatic_installation is handled by lsp-manager
      local settings = require("mason-lspconfig.settings")
      settings.current.automatic_installation = false
    end,
    lazy = true,
    event = "User FileOpened",
    dependencies = "mason.nvim",
  },
  { url = "https://e.coding.net/zydou/vim/nlsp-settings.nvim.git", cmd = "LspSettings", lazy = true },
  { url = "https://e.coding.net/zydou/vim/none-ls.nvim.git", lazy = true },
  {
    url = "https://e.coding.net/zydou/vim/mason.nvim.git",
    config = function() require("lvim.core.mason").setup() end,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = function()
      pcall(function() require("mason-registry").refresh() end)
    end,
    event = "User FileOpened",
    lazy = true,
  },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = not vim.startswith(lvim.colorscheme, "tokyonight"),
  -- },
  {
    url = "https://e.coding.net/zydou/vim/lunar.nvim.git",
    lazy = lvim.colorscheme ~= "lunar",
  },
  { url = "https://e.coding.net/zydou/vim/structlog.nvim.git", lazy = true },
  { url = "https://e.coding.net/zydou/vim/plenary.nvim.git", cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" }, lazy = true },
  -- Telescope
  {
    url = "https://e.coding.net/zydou/vim/telescope.nvim.git",
    branch = "0.1.x",
    config = function() require("lvim.core.telescope").setup() end,
    dependencies = { "telescope-fzf-native.nvim" },
    lazy = true,
    cmd = "Telescope",
    enabled = lvim.builtin.telescope.active,
  },
  { url = "https://e.coding.net/zydou/vim/telescope-fzf-native.nvim.git", build = "make", lazy = true, enabled = lvim.builtin.telescope.active },
  -- Install nvim-cmp, and buffer source as a dependency
  {
    url = "https://e.coding.net/zydou/vim/nvim-cmp.git",
    config = function()
      if lvim.builtin.cmp then require("lvim.core.cmp").setup() end
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "cmp-nvim-lsp",
      "cmp_luasnip",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
  },
  { url = "https://e.coding.net/zydou/vim/cmp-nvim-lsp.git", lazy = true },
  { url = "https://e.coding.net/zydou/vim/cmp_luasnip.git", lazy = true },
  { url = "https://e.coding.net/zydou/vim/cmp-buffer.git", lazy = true },
  { url = "https://e.coding.net/zydou/vim/cmp-path.git", lazy = true },
  {
    url = "https://e.coding.net/zydou/vim/cmp-cmdline.git",
    lazy = true,
    enabled = lvim.builtin.cmp and lvim.builtin.cmp.cmdline.enable or false,
  },
  {
    url = "https://github.com/L3MON4D3/LuaSnip.git", -- has submodule, do not use mirror url
    config = function()
      local utils = require("lvim.utils")
      local paths = {}
      if lvim.builtin.luasnip.sources.friendly_snippets then paths[#paths + 1] = utils.join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt", "friendly-snippets") end
      local user_snippets = utils.join_paths(get_config_dir(), "snippets")
      if utils.is_directory(user_snippets) then paths[#paths + 1] = user_snippets end
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = paths,
      })
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
    event = "InsertEnter",
    dependencies = {
      "friendly-snippets",
    },
  },
  { url = "https://e.coding.net/zydou/vim/friendly-snippets.git", lazy = true, cond = lvim.builtin.luasnip.sources.friendly_snippets },
  {
    url = "https://e.coding.net/zydou/vim/neodev.nvim.git",
    lazy = true,
  },

  -- Autopairs
  {
    url = "https://e.coding.net/zydou/vim/nvim-autopairs.git",
    event = "InsertEnter",
    config = function() require("lvim.core.autopairs").setup() end,
    enabled = lvim.builtin.autopairs.active,
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },

  -- Treesitter
  {
    url = "https://e.coding.net/zydou/vim/nvim-treesitter.git",
    -- run = ":TSUpdate",
    config = function()
      local utils = require("lvim.utils")
      local path = utils.join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt", "nvim-treesitter")
      vim.opt.rtp:prepend(path) -- treesitter needs to be before nvim's runtime in rtp
      require("lvim.core.treesitter").setup()
    end,
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    event = "User FileOpened",
  },
  {
    -- Lazy loaded by Comment.nvim pre_hook
    url = "https://e.coding.net/zydou/vim/nvim-ts-context-commentstring.git",
    lazy = true,
  },

  -- NvimTree
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   config = function()
  --     require("lvim.core.nvimtree").setup()
  --   end,
  --   enabled = lvim.builtin.nvimtree.active,
  --   cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
  --   event = "User DirOpened",
  -- },
  -- Lir
  -- {
  --   "tamago324/lir.nvim",
  --   config = function()
  --     require("lvim.core.lir").setup()
  --   end,
  --   enabled = lvim.builtin.lir.active,
  --   event = "User DirOpened",
  -- },
  {
    url = "https://e.coding.net/zydou/vim/gitsigns.nvim.git",
    config = function() require("lvim.core.gitsigns").setup() end,
    event = "User FileOpened",
    cmd = "Gitsigns",
    enabled = lvim.builtin.gitsigns.active,
  },

  -- Whichkey
  {
    url = "https://e.coding.net/zydou/vim/which-key.nvim.git",
    config = function() require("lvim.core.which-key").setup() end,
    cmd = "WhichKey",
    event = "VeryLazy",
    enabled = lvim.builtin.which_key.active,
  },

  -- Comments
  {
    url = "https://e.coding.net/zydou/vim/Comment.nvim.git",
    config = function() require("lvim.core.comment").setup() end,
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    event = "User FileOpened",
    enabled = lvim.builtin.comment.active,
  },

  -- project.nvim
  -- {
  --   "ahmedkhalf/project.nvim",
  --   config = function()
  --     require("lvim.core.project").setup()
  --   end,
  --   enabled = lvim.builtin.project.active,
  --   event = "VimEnter",
  --   cmd = "Telescope projects",
  -- },

  -- Icons
  {
    url = "https://e.coding.net/zydou/vim/nvim-web-devicons.git",
    enabled = lvim.use_icons,
    lazy = true,
  },

  -- Status Line and Bufferline
  {
    -- "hoob3rt/lualine.nvim",
    url = "https://e.coding.net/zydou/vim/lualine.nvim.git",
    -- "Lunarvim/lualine.nvim",
    config = function() require("lvim.core.lualine").setup() end,
    event = "VimEnter",
    enabled = lvim.builtin.lualine.active,
  },

  -- breadcrumbs
  {
    url = "https://e.coding.net/zydou/vim/nvim-navic.git",
    config = function() require("lvim.core.breadcrumbs").setup() end,
    event = "User FileOpened",
    enabled = lvim.builtin.breadcrumbs.active,
  },

  {
    url = "https://e.coding.net/zydou/vim/bufferline.nvim.git",
    config = function() require("lvim.core.bufferline").setup() end,
    branch = "main",
    event = "User FileOpened",
    enabled = lvim.builtin.bufferline.active,
  },

  -- Debugging
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     require("lvim.core.dap").setup()
  --   end,
  --   lazy = true,
  --   dependencies = {
  --     "rcarriga/nvim-dap-ui",
  --   },
  --   enabled = lvim.builtin.dap.active,
  -- },

  -- Debugger user interface
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   config = function()
  --     require("lvim.core.dap").setup_ui()
  --   end,
  --   lazy = true,
  --   enabled = lvim.builtin.dap.active,
  -- },

  -- alpha
  {
    url = "https://e.coding.net/zydou/vim/alpha-nvim.git",
    config = function() require("lvim.core.alpha").setup() end,
    enabled = lvim.builtin.alpha.active,
    event = "VimEnter",
  },

  -- Terminal
  {
    url = "https://e.coding.net/zydou/vim/toggleterm.nvim.git",
    branch = "main",
    init = function() require("lvim.core.terminal").init() end,
    config = function() require("lvim.core.terminal").setup() end,
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    keys = lvim.builtin.terminal.open_mapping,
    enabled = lvim.builtin.terminal.active,
  },

  -- SchemaStore
  {
    url = "https://e.coding.net/zydou/vim/schemastore.nvim.git",
    lazy = true,
  },

  {
    url = "https://e.coding.net/zydou/vim/vim-illuminate.git",
    config = function() require("lvim.core.illuminate").setup() end,
    event = "User FileOpened",
    enabled = lvim.builtin.illuminate.active,
  },

  {
    url = "https://e.coding.net/zydou/vim/indent-blankline.nvim.git",
    config = function() require("lvim.core.indentlines").setup() end,
    event = "User FileOpened",
    enabled = lvim.builtin.indentlines.active,
  },

  -- {
  --   "lunarvim/onedarker.nvim",
  --   branch = "freeze",
  --   config = function()
  --     pcall(function()
  --       if lvim and lvim.colorscheme == "onedarker" then
  --         require("onedarker").setup()
  --         lvim.builtin.lualine.options.theme = "onedarker"
  --       end
  --     end)
  --   end,
  --   lazy = lvim.colorscheme ~= "onedarker",
  -- },

  {
    url = "https://e.coding.net/zydou/vim/bigfile.nvim.git",
    config = function()
      pcall(function() require("bigfile").setup(lvim.builtin.bigfile.config) end)
    end,
    enabled = lvim.builtin.bigfile.active,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },
}

local default_snapshot_path = join_paths(get_lvim_base_dir(), "snapshots", "default.json")
local content = vim.fn.readfile(default_snapshot_path)
local default_sha1 = assert(vim.fn.json_decode(content))

-- taken from <https://github.com/folke/lazy.nvim/blob/c7122d64cdf16766433588486adcee67571de6d0/lua/lazy/core/plugin.lua#L27>
local get_short_name = function(long_name)
  local name = long_name:sub(-4) == ".git" and long_name:sub(1, -5) or long_name
  local slash = name:reverse():find("/", 1, true) --[[@as number?]]
  return slash and name:sub(#name - slash + 2) or long_name:gsub("%W+", "_")
end

local get_default_sha1 = function(spec)
  local short_name = get_short_name(spec.url)
  return default_sha1[short_name] and default_sha1[short_name].commit
end

if not vim.env.LVIM_DEV_MODE then
  --  Manually lock the commit hashes of core plugins
  for _, spec in ipairs(core_plugins) do
    spec["commit"] = get_default_sha1(spec)
  end
end

return core_plugins
