return {
  {
    LazyDep("nvim-treesitter"),
    lazy = false, -- Does not support lazy loading

    opts = {
      _my_parsers = {
        -- Value indicates if treesitter indentexpr is enabled
        bash = true,
        c = true,
        cpp = true,
        editorconfig = true,
        git_config = true,
        lua = true,
        markdown = true,
        markdown_inline = true,
        meson = true,
        python = true,
        query = true,
        regex = true,
        toml = true,
        vim = true,
        vimdoc = true,
        xml = true,
        yaml = true,
      },
    },

    config = function(_, opts)
      local ts = require("nvim-treesitter")
      ts.setup(opts)

      local parsers = opts._my_parsers or {}
      ts.install(vim.tbl_keys(parsers))

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("my_treesitter", {}),
        desc = "Treesitter features",

        callback = function(args)
          local bufnr = args.buf
          local ok, _ = pcall(vim.treesitter.start, bufnr)

          if ok and opts._my_parsers[args.match] then
            vim.bo[bufnr].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Parsers
  { import = "plugins.treesitter.doxygen" },
  { import = "plugins.treesitter.jjdescription" },
  { import = "plugins.treesitter.luadoc" },
  { import = "plugins.treesitter.zsh" },

  -- Plugins
  { import = "plugins.treesitter.endwise" },
  { import = "plugins.treesitter.jjconfig" },
  { import = "plugins.treesitter.textobjects" },
}
