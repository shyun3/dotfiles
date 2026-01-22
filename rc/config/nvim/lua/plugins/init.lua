return {
  {
    LazyDep("Comment"),
    opts = {},
    keys = { "gc", "gb" },
  },

  {
    "vim-scripts/DoxygenToolkit.vim",

    keys = {
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
      {
        "gx",
        "<Cmd>Browse<CR>",
        mode = { "n", "x" },
        desc = "Open link in browser",
      },
    },
  },

  {
    LazyDep("ibl"),
    event = "VeryLazy",

    main = "ibl",

    opts_extend = { "exclude.filetypes" },

    opts = {
      indent = {
        char = "│", -- center aligned solid
      },

      whitespace = { remove_blankline_trail = false },

      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",

    -- Taken from https://github.com/iamcco/markdown-preview.nvim/issues/690#issuecomment-2782326124
    build = ":call mkdp#util#install()",

    -- For some reason, this is needed as the key mapping fails on first use
    ft = "markdown",

    config = function()
      -- This plugin uses `cmd.exe` even on WSL
      -- See https://github.com/iamcco/markdown-preview.nvim/issues/710
      if vim.fn.has("wsl") == 1 then
        vim.env.PATH = vim.env.PATH .. ":/mnt/c/Windows/System32/"
      end
    end,

    keys = {
      {
        "<Leader>mp",
        "<Cmd>MarkdownPreview<CR>",
        ft = "markdown",
        desc = "Markdown preview",
      },
    },
  },

  {
    "monkoose/matchparen.nvim",
    event = "UIEnter",

    init = function() vim.g.loaded_matchparen = 1 end,

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
    "chrisgrieser/nvim-spider",

    keys = {
      -- For dot-repeat to work, motions must be called as Ex commands
      {
        "<Leader>w",
        "<Cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "x", "o" },
        desc = "Next subword",
      },
      {
        "<Leader>e",
        "<Cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "x", "o" },
        desc = "Next end of subword",
      },
      {
        "<Leader>b",
        "<Cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "x", "o" },
        desc = "Previous subword",
      },
      {
        "<Leader>ge",
        "<Cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "x", "o" },
        desc = "Previous end of subword",
      },
    },
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
      {
        "<Leader>j",
        "<Cmd>FloatermNew --title=jjui --width=0.9 --height=0.9 jjui<CR>",
        desc = "floaterm: Open jjui",
      },
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
    "tadaa/vimade",
    event = "UIEnter",

    opts = {
      ncmode = "windows",
      fadelevel = 0.6,
      enablefocusfading = true,
      usecursorhold = true,
    },

    config = function(_, opts)
      -- When nvim focus is lost, lualine may not refresh before vimade fades.
      -- The nvim display does not seem to update after fade. So, force a
      -- lualine refresh before fade.
      --
      -- Make sure this autocommand is registered before vimade so that the
      -- lualine refresh will occur before fade.
      vim.api.nvim_create_autocmd("FocusLost", {
        group = vim.api.nvim_create_augroup("my_vimade", {}),
        callback = function() require("lualine").refresh({ force = true }) end,
      })

      require("vimade").setup(opts)
    end,
  },
}
