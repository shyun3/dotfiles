local highlight_disable_langs = { "c", "cpp", "python" }

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "RRethy/nvim-treesitter-endwise",
  },
  lazy = false, -- Does not support lazy loading

  branch = "master",
  build = ":TSUpdate",

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
      "meson",
      "python",
      "regex", -- Recommended by noice
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
      enable = true,

      disable = function(lang, buf)
        if vim.tbl_contains(highlight_disable_langs, lang) then return true end

        -- disable slow treesitter highlight for large files
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
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

          ad = {
            -- Derived from https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/439#issuecomment-1505411083
            query = "@string.documentation",
            query_group = "highlights",
            desc = "Select docstring, outer",
          },
          id = {
            query = "@documentation.inner",
            desc = "Select docstring, inner",
          },
        },
      },
    },

    endwise = { enable = true },
  },

  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    -- Disabling treesitter highlighting also disables text objects, see
    -- nvim-treesitter-textobjects#746. Manually force treesitter evaluation
    -- for highlight disabled languages as a workaround.
    --
    -- Derived from https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/746#issuecomment-2861663503
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", {}),
      desc = "Load treesitter parser and parse tree",
      pattern = highlight_disable_langs,

      callback = function(ev)
        local parsers = require("nvim-treesitter.parsers")
        local lang = parsers.get_buf_lang(ev.buf)
        local parser =
          vim.treesitter.get_parser(ev.buf, lang, { error = false })
        if parser then parser:parse() end
      end,
    })
  end,
}
