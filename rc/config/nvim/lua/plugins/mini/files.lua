-- Derived from example in mini.files help
local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
    MiniFiles.go_in()
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

-- Derived from example in mini.files help
-- Set focused directory as current working directory
local set_cwd = function()
  local fs_entry = (MiniFiles.get_fs_entry() or {})
  if fs_entry.path == nil then
    return vim.notify("Cursor is not on valid entry")
  end

  vim.fn.chdir(
    fs_entry.fs_type == "file" and vim.fs.dirname(fs_entry.path)
      or fs_entry.path
  )
end

-- Taken from "Set custom bookmarks" section in `MiniFiles-examples`
local set_mark = function(id, path, desc)
  MiniFiles.set_bookmark(id, path, { desc = desc })
end

return {
  LazyDep("mini.files"),
  version = false, -- Main branch

  opts_extend = {
    "_my_event_callbacks.MiniFilesBufferCreate",
    "_my_event_callbacks.MiniFilesExplorerOpen",
  },

  opts = {
    windows = { preview = true },

    _my_event_callbacks = {
      MiniFilesBufferCreate = {
        -- Derived from examples in help
        {
          desc = "Add mappings",
          callback = function(args)
            local buf_id = args.data.buf_id
            map_split(buf_id, "<C-s>", "horizontal")
            map_split(buf_id, "<C-v>", "vertical")
            vim.keymap.set(
              "n",
              "g~",
              set_cwd,
              { buffer = buf_id, desc = "Set cwd" }
            )
          end,
        },
      },

      MiniFilesExplorerOpen = {
        -- Derived from "Set custom bookmarks" section in `MiniFiles-examples`
        {
          desc = "Set custom bookmarks",
          callback = function()
            set_mark("w", vim.fn.getcwd, "Working directory")
          end,
        },
      },
    },
  },

  config = function(_, opts)
    require("mini.files").setup(opts)

    local group = vim.api.nvim_create_augroup("my_mini_files", {})
    if opts._my_event_callbacks then
      local events = { "MiniFilesBufferCreate", "MiniFilesExplorerOpen" }
      for _, ev in ipairs(events) do
        for _, autocmd_opts in ipairs(opts._my_event_callbacks[ev] or {}) do
          vim.api.nvim_create_autocmd("User", {
            group = group,
            pattern = ev,
            desc = autocmd_opts.desc,
            callback = autocmd_opts.callback,
          })
        end
      end
    end

    -- Taken from rename snack
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "MiniFilesActionRename",
      desc = "LSP-integrated file rename",

      callback = function(event)
        require("snacks").rename.on_rename_file(event.data.from, event.data.to)
      end,
    })
  end,

  keys = {
    {
      "<C-n>",

      function()
        -- Derived from "Toggle explorer" section in `MiniFiles-examples`
        if not MiniFiles.close() then
          MiniFiles.open(MiniFiles.get_latest_path())
        end
      end,

      desc = "Toggle MiniFiles",
    },

    {
      "<A-n>",
      function()
        -- Taken from `MiniFiles.open()` help
        -- Open current file directory (in last used state) focused on the file
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
      end,
      desc = "Open MiniFiles in directory of current file",
    },
  },
}
