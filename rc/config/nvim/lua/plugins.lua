return {
  {
    "numToStr/Comment.nvim",
    lazy = false, -- To allow which-key to load descriptions for mappings

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

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",

    opts = {},

    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- This plugin creates its mappings through an autocommand, so update
      -- the descriptions afterwards
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        group = vim.api.nvim_create_augroup("user_autopairs", {}),
        pattern = "*",

        -- Other mappings may be overriden by blink.cmp
        callback = function()
          if vim.b["nvim-autopairs"] == 1 then
            require("util").update_keymap_desc("i", "<BS>", "autopairs delete")
          end
        end,

        desc = "nvim-autopairs: Update mapping descriptions",
      })
    end,
  },

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
        desc = "N subwords forward",
      },
      {
        "<Leader>e",
        "<Plug>WordMotion_e",
        mode = { "n", "x", "o" },
        desc = "Forward to end of subword N",
      },
      {
        "<Leader>b",
        "<Plug>WordMotion_b",
        mode = { "n", "x", "o" },
        desc = "N subwords backward",
      },
      {
        "<Leader>ge",
        "<Plug>WordMotion_ge",
        mode = { "n", "x", "o" },
        desc = "Backward to end of subword N",
      },

      {
        "i<Leader>w",
        "<Plug>WordMotion_iw",
        mode = { "o", "x" },
        desc = "Select N inner subwords",
      },
      {
        "a<Leader>w",
        "<Plug>WordMotion_aw",
        mode = { "o", "x" },
        desc = "Select N subwords",
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
