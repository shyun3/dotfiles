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

      vim.cmd.highlight("link WinBarNC Comment")
    end,
  },

  { "numToStr/Comment.nvim", opts = {} },
  "vim-scripts/DoxygenToolkit.vim",

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
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    lazy = true,

    config = function()
      for _, fmt in ipairs({ "vscode", "snipmate" }) do
        local module = string.format("luasnip.loaders.from_%s", fmt)
        require(module).lazy_load({
          lazy_paths = { "./snippets/specific" },
        })
      end

      -- Update repeated placeholders while typing in insert mode
      -- Derived from https://github.com/L3MON4D3/LuaSnip/wiki/Migrating-from-UltiSnips#update-placeholders
      local luasnip = require("luasnip")
      luasnip.setup({
        update_events = { "TextChanged", "TextChangedI" },
      })

      -- Derived from https://github.com/L3MON4D3/LuaSnip/issues/656#issuecomment-1500869758
      local function stop_snippet()
        -- If we have n active nodes, n - 1 will still remain after a `unlink_current()` call.
        -- We unlink all of them by wrapping the calls in a loop.
        while true do
          if
            luasnip.session
            and luasnip.session.current_nodes[vim.fn.bufnr()]
            and not luasnip.session.jump_active
          then
            luasnip.unlink_current()
          else
            break
          end
        end
      end

      -- Derived from https://github.com/Saghen/blink.cmp/issues/1805#issuecomment-2912427954
      vim.keymap.set({ "n", "i", "s" }, "<Esc>", function()
        stop_snippet()
        return "<Esc>"
      end, { silent = true, expr = true, desc = "Escape and stop snippet" })
    end,
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
    "majutsushi/tagbar",
    init = function()
      vim.g.tagbar_autofocus = 1 -- Move to Tagbar window when opened
      vim.g.tagbar_sort = 0
    end,

    keys = { { "<A-t>", "<Cmd>TagbarToggle<CR>" } },
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
    lazy = false,

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
