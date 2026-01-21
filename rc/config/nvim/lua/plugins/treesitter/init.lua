return {
  {
    LazyDep("mason-lspconfig"),
    optional = true,

    opts = {
      _my_lsp_configs = {
        ts_query_ls = {
          -- Taken from https://github.com/ribru17/ts_query_ls#example-setup-for-neovim
          init_options = {
            parser_install_directories = {
              -- If using nvim-treesitter with lazy.nvim
              vim.fs.joinpath(
                vim.fn.stdpath("data"),
                "/lazy/nvim-treesitter/parser/"
              ),
            },
          },
        },
      },
    },
  },

  {
    "shyun3/nvim-treesitter",
    branch = "personal",

    lazy = false, -- Does not support lazy loading

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
        "doxygen",
        "git_config",
        "luadoc",
        "meson",
        "python",
        "regex",
        "toml",
        "xml",
        "yaml",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

      highlight = {
        enable = true,

        disable = function(_, buf)
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
    branch = "master",
    event = "ModeChanged",

    main = "nvim-treesitter.configs",

    opts = {
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = false,
        },

        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist

          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]["] = { query = "@class.outer", desc = "Next class end" },
          },
          goto_previous_start = {
            ["[m"] = {
              query = "@function.outer",
              desc = "Previous function start",
            },
            ["[["] = { query = "@class.outer", desc = "Previous class start" },
          },
          goto_previous_end = {
            ["[M"] = {
              query = "@function.outer",
              desc = "Previous function end",
            },
            ["[]"] = { query = "@class.outer", desc = "Previous class end" },
          },
        },
      },
    },
  },

  { import = "plugins.treesitter.endwise" },
  { import = "plugins.treesitter.jjconfig" },
}
