return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",

    main = "nvim-treesitter.configs",
    opts = {
      -- A list of parser names, or "all"
      ensure_installed = {
        -- These parsers MUST always be installed
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",

        "bash",
        "cpp",
        "regex", -- Recommended by noice
        "meson",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

      highlight = {
        enable = true,

        disable = function(lang, buf)
          local disable_langs = { "c", "cpp" }
          if vim.tbl_contains(disable_langs, lang) then return true end

          -- disable slow treesitter highlight for large files
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats =
            pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return true end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",

    main = "nvim-treesitter.configs",
    opts = {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = false,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = {
              query = "@function.outer",
              desc = "Select function, outer",
            },
            ["if"] = {
              query = "@function.inner",
              desc = "Select function, inner",
            },
            ["ak"] = { query = "@class.outer", desc = "Select class, outer" },
            ["ik"] = { query = "@class.inner", desc = "Select class, inner" },
          },
        },
      },
    },
  },

  {
    "RRethy/nvim-treesitter-endwise",
    dependencies = "nvim-treesitter/nvim-treesitter",

    main = "nvim-treesitter.configs",
    opts = { endwise = { enable = true } },
  },
}
