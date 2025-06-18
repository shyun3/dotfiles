local lazygit_timer

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
    end,
  },

  { "numToStr/Comment.nvim", opts = {} },
  { "vim-scripts/DoxygenToolkit.vim" },

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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
    "folke/snacks.nvim",

    opts = {
      lazygit = {
        theme = {
          activeBorderColor = { fg = "Character", bold = true },
          searchingActiveBorderColor = { fg = "IncSearch", bold = true },
        },
        win = {
          style = "lazygit",

          -- For some reason, the `WinEnter` event doesn't fire when exiting
          -- the lazygit window and re-entering the previous one. This is being
          -- manually fired here because there may be some custom autocommands
          -- that depend on it.
          on_close = function()
            lazygit_timer = vim.uv.new_timer()
            lazygit_timer:start(20, 0, function()
              lazygit_timer:stop()
              lazygit_timer:close()
              vim.schedule(
                function() vim.api.nvim_exec_autocmds("WinEnter", {}) end
              )
            end)
          end,
        },
      },
    },

    keys = {
      {
        "<Leader>lg",
        function()
          -- Using module instead of `Snacks` to avoid undefined global
          require("snacks").lazygit()
        end,
        desc = "Open lazygit",
      },
    },
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
    "SirVer/ultisnips",
    init = function()
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips", "UltiSnips/specific" }

      -- Handled by cmp
      --
      -- Note that if triggers are left empty, UltiSnips emits "No mapping
      -- found" messages. Untypable character is used as a workaround.
      vim.g.UltiSnipsExpandTrigger = "�"
    end,
  },

  {
    "haya14busa/vim-asterisk",
    init = function() vim.g["asterisk#keeppos"] = 1 end,

    keys = {
      { "*", "<Plug>(asterisk-*)", mode = "" },
      { "#", "<Plug>(asterisk-#)", mode = "" },
      { "g*", "<Plug>(asterisk-g*)", mode = "" },
      { "g#", "<Plug>(asterisk-g#)", mode = "" },
      { "z*", "<Plug>(asterisk-z*)", mode = "" },
      { "gz*", "<Plug>(asterisk-gz*)", mode = "" },
      { "z#", "<Plug>(asterisk-z#)", mode = "" },
      { "gz#", "<Plug>(asterisk-gz#)", mode = "" },
    },
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

    build = function()
      -- Unknown function call error is emitted if install is run directly on
      -- build (maybe related to vim-doge#358), so schedule it to run later.
      -- Make sure plugin is loaded before then or the same error will occur.
      vim.api.nvim_create_autocmd("VimEnter", {
        -- For some reason, this autocommand does not get registered when also
        -- specifying a group
        pattern = "*",
        once = true,
        command = "call doge#install()",
      })
    end,

    init = function()
      vim.g.doge_doc_standard_python = "google"
      vim.g.doge_comment_jump_modes = { "n", "s" }
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "chaoren/vim-wordmotion",
    init = function() vim.g.wordmotion_nomap = 1 end,

    keys = {
      { "<Leader>w", "<Plug>WordMotion_w", mode = "" },
      { "<Leader>e", "<Plug>WordMotion_e", mode = "" },
      { "<Leader>b", "<Plug>WordMotion_b", mode = "" },
      { "<Leader>ge", "<Plug>WordMotion_ge", mode = "" },

      { "i<Leader>w", "<Plug>WordMotion_iw", mode = { "o", "v" } },
      { "a<Leader>w", "<Plug>WordMotion_aw", mode = { "o", "v" } },
    },
  },

  {
    "jannis-baum/vivify.vim",

    -- Plugin must be loaded before file load, not on command. Crucial
    -- autocommands are created on file load, see vivify.vim.
    ft = "markdown",
  },
}
