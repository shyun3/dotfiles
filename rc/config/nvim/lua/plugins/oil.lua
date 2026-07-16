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

              if #path < 20 then
                return path
              else
                -- Path ends with slash. Remove it so that the last component
                -- won't also be shortened.
                local dir = vim.fn.fnamemodify(path, ":h")
                return vim.fn.pathshorten(dir)
              end
            end,
          },
        },
      },
    },
  },

  {
    LazyDep("toggleterm"),
    optional = true,

    opts = {
      -- If a toggleterm is not set to close on exit (see `close_on_exit`),
      -- then the window displays a "Process exited..." message when the
      -- terminal process is shut down. Then, if any key is pressed, the window
      -- is closed.
      --
      -- However, the window seems to stay open if only Oil buffers were open
      -- at the time of exit. A workaround is to create a scratch buffer
      -- when the terminal is launched and delete it after exit.
      --
      -- See dotfiles#30
      on_create = function(term)
        -- Buffer must be listed
        local scratch_bufnr = vim.api.nvim_create_buf(true, true)

        vim.api.nvim_create_autocmd("BufDelete", {
          group = vim.api.nvim_create_augroup("my_toggleterm", {}),
          nested = true,
          once = true,
          desc = "Delete workaround scratch buffer",

          callback = function(args)
            if args.buf == term.bufnr then
              vim.api.nvim_buf_delete(scratch_bufnr, { force = true })
            end
          end,
        })
      end,
    },
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

      local group = vim.api.nvim_create_augroup("my_oil", {})
      for _, autocmd_opts in pairs(opts._my_post_actions or {}) do
        vim.api.nvim_create_autocmd("User", {
          group = group,
          pattern = "OilActionsPost",
          desc = autocmd_opts.desc,
          callback = autocmd_opts.callback,
        })
      end
    end,

    keys = {
      { "-", "<Cmd>Oil<CR>" },
    },
  },
}
