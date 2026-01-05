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
            if vim.startswith(bufname, "oil://") then
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
    LazyDep("oil"),
    event = "UIEnter",

    init = function()
      -- Although oil can disable netrw when it loads, the latter must be
      -- disabled on startup to prevent netrw usage when loading oil late and
      -- opening a folder directly as a CLI argument
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,

    opts = {
      keymaps = {
        ["<C-p>"] = false, -- Conflicts with fzf-lua
        gp = "actions.preview",
      },
    },

    config = function(_, opts)
      require("oil").setup(opts)

      require("util.path").register_normalizer(function(path)
        local prefix = "oil://"
        return vim.startswith(path, prefix)
          and string.sub(path, #prefix + 1, -1)
      end)
    end,
  },
}
