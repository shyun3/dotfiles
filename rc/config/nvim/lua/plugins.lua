return {
  { "numToStr/Comment.nvim", keys = { "gc", "gb" }, opts = {} },

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
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",

    event = "BufWinEnter",

    opts = {
      indent = {
        char = "│", -- center aligned solid
      },

      whitespace = { remove_blankline_trail = false },

      scope = {
        show_start = false,
        show_end = false,
      },

      exclude = { filetypes = { "project" } },
    },
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",

    config = function()
      require("colorizer").setup({ "*" }, { RGB = false, names = false })
    end,
  },

  {
    "yorickpeterse/nvim-window",

    keys = {
      {
        "<Leader><Space>",
        function() require("nvim-window").pick() end,
        desc = "Jump to window",
      },
    },
  },

  {
    "stevearc/oil.nvim",
    event = "VimEnter", -- Should be loaded early to override netrw

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

    config = true,

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
