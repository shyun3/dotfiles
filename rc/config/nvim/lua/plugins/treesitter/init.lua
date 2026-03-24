return {
  {
    LazyDep("nvim-treesitter"),
    lazy = false, -- Does not support lazy loading
    build = ":TSUpdate",

    opts = {
      _my_parsers = {
        c = false,
        lua = false,
        vim = false,
        vimdoc = false,
        query = false,
        markdown = false,
        markdown_inline = false,
        bash = false,
        cpp = false,
        editorconfig = false,
        git_config = false,
        meson = false,
        python = false,
        regex = false,
        toml = false,
        xml = false,
        yaml = false,
        zsh = false,
      },
    },

    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup(opts)

      local parsers = opts._my_parsers or {}
      ts.install(vim.tbl_keys(parsers))

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("my_treesitter", {}),
        desc = "Treesitter: Highlight",

        callback = function(args)
          local bufnr = args.buf

          -- disable slow treesitter highlight for large files
          local max_filesize = 1024 * 1024
          local ok, stats =
            pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size <= max_filesize then
            pcall(vim.treesitter.start, bufnr)
          end

          local parser, _ = vim.treesitter.get_parser(bufnr)
          if parser then
            vim.bo[bufnr].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Parsers
  { import = "plugins.treesitter.doxygen" },
  { import = "plugins.treesitter.luadoc" },

  -- Plugins
  { import = "plugins.treesitter.endwise" },
  { import = "plugins.treesitter.jjconfig" },
  { import = "plugins.treesitter.textobjects" },
}
