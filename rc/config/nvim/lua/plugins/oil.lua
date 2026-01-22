local OIL_PATH_PREFIX = "oil://"

return {
  {
    LazyDep("dropbar"),
    optional = true,

    opts = {
      sources = {
        path = {
          -- Derived from https://github.com/Bekaboo/dropbar.nvim#normalize-path-in-special-buffers
          relative_to = function(buf, win)
            -- Show full path in oil buffers
            local bufname = vim.api.nvim_buf_get_name(buf)
            if vim.startswith(bufname, OIL_PATH_PREFIX) then
              local root = bufname:gsub("^%S+://", "", 1)
              while root and root ~= vim.fs.dirname(root) do
                root = vim.fs.dirname(root)
              end
              return root
            end

            local ok, cwd = pcall(vim.fn.getcwd, win)
            return ok and cwd or vim.fn.getcwd()
          end,
        },
      },
    },
  },

  {
    LazyDep("lualine"),
    optional = true,

    opts = { extensions = { "my_oil" } },
  },

  {
    LazyDep("mini.files"),
    optional = true,

    opts = {
      options = { use_as_default_explorer = false },
    },
  },

  {
    LazyDep("tabby"),
    optional = true,

    opts = {
      option = {
        tab_name = {
          _my_name_fallbacks = {
            oil = function(buf_id)
              local raw_buf_name = vim.api.nvim_buf_get_name(buf_id)
              local path = vim.fn.fnamemodify(
                require("util.path").normalize(raw_buf_name),
                ":~"
              )
              return #path < 20 and path or vim.fn.pathshorten(path)
            end,
          },
        },
      },
    },
  },

  {
    LazyDep("vim-project"),
    optional = true,

    opts = { _my_autocmd_patterns = { OIL_PATH_PREFIX .. "*" } },
  },

  {
    LazyDep("oil"),
    event = "UIEnter",

    init = function()
      -- Although oil can disable netrw when it loads, the latter must be
      -- disabled on startup to prevent netrw usage when loading oil late and
      -- opening a folder directly as a CLI argument
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,

    config = function(_, opts)
      require("oil").setup(opts)

      require("util.path").register_normalizer(
        function(path)
          return vim.startswith(path, OIL_PATH_PREFIX)
            and string.sub(path, #OIL_PATH_PREFIX + 1, -1)
        end
      )
    end,
  },
}
