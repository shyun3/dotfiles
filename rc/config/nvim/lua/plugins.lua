return {
  -- the colorscheme should be available when starting Neovim
  {
    "shyun3/molokai",
    branch = "personal",

    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins

    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme molokai]])

      -- See `:h treesitter-highlight-groups`
      vim.api.nvim_set_hl(0, "@variable", { fg = "fg" })
      vim.cmd.highlight("link @variable.parameter NONE")

      -- See `:h lsp-semantic-highlight`
      vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = "fg" })
      vim.cmd.highlight("link @lsp.type.parameter NONE")

      -- Taken from default vscode theme (Dark Modern)
      vim.cmd.highlight("IndentLine guifg=#404040")
      vim.cmd.highlight("IndentLineCurrent guifg=#707070")

      -- Work around nvim 0.11 statusline changes, see neovim PR #29976
      -- Derived from https://github.com/vim-airline/vim-airline/issues/2693#issuecomment-2424151997
      vim.cmd.highlight("TabLine cterm=NONE gui=NONE")
      vim.cmd.highlight("TabLineFill cterm=NONE gui=NONE")

      vim.cmd.highlight("link WinBarNC Comment")
    end,
  },

  { "numToStr/Comment.nvim", opts = {} },

  {
    "vim-scripts/DoxygenToolkit.vim",

    keys = {
      -- Note that this is intended to overwrite the doge mapping
      { "<Leader>d", "<Cmd>Dox<CR>", ft = { "c", "cpp" } },
    },
  },

  {
    "chrishrb/gx.nvim",

    init = function() vim.g.netrw_nogx = 1 end,
    config = true,

    keys = { { "gx", "<Cmd>Browse<CR>", mode = { "n", "x" } } },
    cmd = "Browse",
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufWinEnter",

    opts = {
      indent = {
        char = "│", -- center aligned solid
        highlight = "IndentLine",
      },

      whitespace = { remove_blankline_trail = false },

      scope = {
        show_start = false,
        show_end = false,
        highlight = "IndentLineCurrent",
      },

      exclude = { filetypes = { "project" } },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufWinEnter",

    init = function()
      -- 'termguicolors' is auto-detected as of nvim 0.10, but the plugin
      -- requires the option to be set. It could be loaded later to wait for
      -- the auto-detect, e.g. at VeryLazy, but that may result in a visual
      -- glitch at startup. See issue #96.
      vim.o.termguicolors = true
    end,

    config = function()
      require("colorizer").setup({ "*" }, { RGB = false, names = false })
    end,
  },

  {
    "stevearc/oil.nvim",
    lazy = false, -- To override netrw as early as possible

    opts = {
      keymaps = {
        ["<C-p>"] = false, -- Conflicts with fzf-lua
        gp = "actions.preview",
      },
    },
  },

  {
    "yssl/QFEnter",
    init = function()
      vim.g.qfenter_keymap = { vopen = { "<C-v>" }, hopen = { "<C-s>" } }
    end,

    ft = "qf",
  },

  {
    "majutsushi/tagbar",
    init = function()
      vim.g.tagbar_autofocus = 1 -- Move to Tagbar window when opened
      vim.g.tagbar_sort = 0
    end,

    keys = { { "<A-t>", "<Cmd>TagbarToggle<CR>" } },
  },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",

    config = function()
      require("undotree").setup()

      -- Derived from https://github.com/jiaoshijie/undotree/issues/23#issuecomment-2602625831
      vim.api.nvim_set_hl(0, "UndotreeDiffAdded", { fg = "#00FF00" })
      vim.api.nvim_set_hl(0, "UndotreeDiffRemoved", { fg = "#FF0000" })
    end,

    keys = {
      {
        "<Leader>u",
        function() require("undotree").toggle() end,
        desc = "Toggle undotree",
      },
    },
  },

  { "shyun3/vim-cmake-lists", ft = "cmake" },

  {
    "kkoomen/vim-doge",
    lazy = false, -- Needed for build to work
    build = ":call doge#install()",

    init = function()
      vim.g.doge_mapping_comment_jump_forward = "<C-j>"
      vim.g.doge_mapping_comment_jump_backward = "<C-k>"
      vim.g.doge_comment_jump_modes = { "i", "s" }

      vim.g.doge_doc_standard_python = "google"
    end,
  },

  {
    "voldikss/vim-floaterm",
    cmd = "FloatermNew",
    keys = {
      { "<Leader>t", "<Cmd>FloatermNew<CR>" },
    },
  },

  {
    "ludovicchabant/vim-gutentags",
    init = function()
      vim.g.gutentags_define_advanced_commands = 1

      vim.g.gutentags_project_root = { ".gutctags" }
      vim.g.gutentags_add_default_project_roots = 0
      vim.g.gutentags_add_ctrlp_root_markers = 0

      vim.g.gutentags_ctags_tagfile = ".gutentags"
    end,
  },

  {
    "jeetsukumaran/vim-pythonsense",
    init = function() vim.g.is_pythonsense_suppress_object_keymaps = 1 end,
    ft = "python",
  },

  {
    "chaoren/vim-wordmotion",
    init = function() vim.g.wordmotion_nomap = 1 end,

    keys = {
      { "<Leader>w", "<Plug>WordMotion_w", mode = { "n", "x", "o" } },
      { "<Leader>e", "<Plug>WordMotion_e", mode = { "n", "x", "o" } },
      { "<Leader>b", "<Plug>WordMotion_b", mode = { "n", "x", "o" } },
      { "<Leader>ge", "<Plug>WordMotion_ge", mode = { "n", "x", "o" } },

      { "i<Leader>w", "<Plug>WordMotion_iw", mode = { "o", "x" } },
      { "a<Leader>w", "<Plug>WordMotion_aw", mode = { "o", "x" } },
    },
  },

  {
    "tadaa/vimade",
    event = "VeryLazy",

    opts = { ncmode = "windows", fadelevel = 0.6 },
  },

  {
    "jannis-baum/vivify.vim",

    -- Plugin must be loaded before file load, not on command. Crucial
    -- autocommands are created on file load, see vivify.vim.
    ft = "markdown",
  },
}
