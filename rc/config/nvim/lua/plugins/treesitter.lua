return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-endwise",
    },
    branch = "master",
    build = ":TSUpdate",

    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
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

        endwise = { enable = true },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",

    opts = {},

    keys = {
      {
        "[c",
        function() require("treesitter-context").go_to_context(vim.v.count1) end,
        desc = "Jump to context (upwards)",
        silent = true,
      },
    },
  },
}
