return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy", -- To allow which-key to load descriptions for mappings

    opts = {},
  },

  {
    "vim-scripts/DoxygenToolkit.vim",

    keys = {
      -- Note that this is intended to overwrite the doge mapping
      {
        "<Leader>d",
        "<Cmd>Dox<CR>",
        ft = { "c", "cpp" },
        desc = "Generate Doxygen comment",
      },
    },
  },

  {
    "chrishrb/gx.nvim",

    init = function() vim.g.netrw_nogx = 1 end,
    config = true,

    keys = {
      { "gx", "<Cmd>Browse<CR>", mode = { "n", "x" } },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",

    main = "ibl",

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

  {
    require("lazy-deps").autopairs,
    event = "InsertEnter",

    opts = {},
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",

    config = function()
      require("colorizer").setup({ "*" }, { RGB = false, names = false })
    end,
  },

  {
    "kylechui/nvim-surround",

    -- So that which-key will properly list surround group at startup
    event = "VeryLazy",

    opts = {
      keymaps = {
        normal = "Sy",
        normal_cur = "Syy",
        normal_line = "SY",
        normal_cur_line = "SYY",

        delete = "Sd",

        change = "Sc",
        change_line = "SC",
      },

      aliases = {
        a = false,
        b = { ")", "}", "]" },
        B = false,
        r = false,
        s = false,
      },
    },

    config = function(_, opts)
      require("nvim-surround").setup(opts)

      require("which-key").add({
        { "S", desc = "Surround" },
      })
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
    lazy = false, -- Should be loaded early to override netrw

    opts = {
      keymaps = {
        ["<C-p>"] = false, -- Conflicts with fzf-lua
        gp = "actions.preview",
      },
    },
  },

  {
    "majutsushi/tagbar",

    init = function()
      vim.g.tagbar_autofocus = 1 -- Move to Tagbar window when opened
      vim.g.tagbar_sort = 0
    end,

    keys = { { "<A-t>", "<Cmd>TagbarToggle<CR>", desc = "Tagbar: Toggle" } },
  },

  {
    "jiaoshijie/undotree",

    keys = {
      {
        "<Leader>u",
        function() require("undotree").toggle() end,
        desc = "undotree: Toggle",
      },
    },
  },

  {
    "shyun3/vim-asterisk",
    branch = "personal",

    init = function() vim.g["asterisk#keeppos"] = 1 end,

    keys = {
      {
        "*",
        "<Plug>(asterisk-*)",
        desc = "Search forward for whole word",
      },
      {
        "*",
        "<Plug>(asterisk-*)",
        mode = "x",
        desc = "Search forward for selection",
      },
      {
        "#",
        "<Plug>(asterisk-#)",
        desc = "Search backward for whole word",
      },
      {
        "#",
        "<Plug>(asterisk-#)",
        mode = "x",
        desc = "Search backward for selection",
      },
      {
        "g*",
        "<Plug>(asterisk-g*)",
        desc = "Search forward for word",
      },
      {
        "g#",
        "<Plug>(asterisk-g#)",
        desc = "Search backward for word",
      },
      {
        "z*",
        "<Plug>(asterisk-z*)",
        desc = "Highlight all occurrences of whole word, set direction forward",
      },
      {
        "z*",
        "<Plug>(asterisk-z*)",
        mode = "x",
        desc = "Highlight all occurrences of selection, set direction forward",
      },
      {
        "gz*",
        "<Plug>(asterisk-gz*)",
        desc = "Highlight all occurrences of word, set direction forward",
      },
      {
        "z#",
        "<Plug>(asterisk-z#)",
        desc = "Highlight all occurrences of whole word, set direction backward",
      },
      {
        "z#",
        "<Plug>(asterisk-z#)",
        mode = "x",
        desc = "Highlight all occurrences of selection, set direction backward",
      },
      {
        "gz#",
        "<Plug>(asterisk-gz#)",
        desc = "Highlight all occurrences of word, set direction backward",
      },
    },
  },

  { "shyun3/vim-cmake-lists", ft = "cmake" },

  {
    "kkoomen/vim-doge",
    lazy = false, -- Needed for build to work

    build = ":call doge#install()",

    init = function()
      vim.g.doge_enable_mappings = 0
      vim.g.doge_buffer_mappings = 0
      vim.g.doge_comment_jump_modes = { "i", "s" }

      vim.g.doge_doc_standard_python = "google"
    end,

    keys = {
      {
        "<Leader>d",
        "<Plug>(doge-generate)",
        silent = true,
        desc = "doge: Generate comment",
      },
      {
        "<C-j>",
        "<Plug>(doge-comment-jump-forward)",
        mode = { "i", "s" },
        silent = true,
        desc = "doge: Jump to next TODO",
      },
      {
        "<C-k>",
        "<Plug>(doge-comment-jump-backward)",
        mode = { "i", "s" },
        silent = true,
        desc = "doge: Jump to previous TODO",
      },
    },
  },

  {
    "voldikss/vim-floaterm",
    cmd = "FloatermNew",
    keys = {
      { "<Leader>t", "<Cmd>FloatermNew<CR>", desc = "floaterm: Open window" },
    },
  },

  {
    "ludovicchabant/vim-gutentags",
    event = "VeryLazy",

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
      {
        "<Leader>w",
        "<Plug>WordMotion_w",
        mode = { "n", "x", "o" },
        desc = "Next subword",
      },
      {
        "<Leader>e",
        "<Plug>WordMotion_e",
        mode = { "n", "x", "o" },
        desc = "Next end of subword",
      },
      {
        "<Leader>b",
        "<Plug>WordMotion_b",
        mode = { "n", "x", "o" },
        desc = "Previous subword",
      },
      {
        "<Leader>ge",
        "<Plug>WordMotion_ge",
        mode = { "n", "x", "o" },
        desc = "Previous end of subword",
      },

      {
        "i<Leader>w",
        "<Plug>WordMotion_iw",
        mode = { "o", "x" },
        desc = "Subword",
      },
      {
        "a<Leader>w",
        "<Plug>WordMotion_aw",
        mode = { "o", "x" },
        desc = "Subword",
      },
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
