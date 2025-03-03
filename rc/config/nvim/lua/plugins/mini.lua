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

return {
  {
    "echasnovski/mini.files",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
    version = false, -- Main branch

    opts = {
      options = {
        -- When on opened directory, current window can get closed with fzf-lua
        -- Ctrl-P
        use_as_default_explorer = false,
      },
      windows = {
        preview = true,
      },
    },

    config = function(_, opts)
      require("mini.files").setup(opts)

      -- Derived from examples in help
      local group = vim.api.nvim_create_augroup("user_mini_files", {})
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          map_split(buf_id, "<C-s>", "belowright horizontal")
          map_split(buf_id, "<C-v>", "belowright vertical")
          vim.keymap.set(
            "n",
            "g~",
            set_cwd,
            { buffer = buf_id, desc = "Set cwd" }
          )
        end,
      })

      -- Taken from rename snack
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesActionRename",
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,

    keys = {
      {
        "<C-n>",
        function()
          -- Derived from example in help
          if not MiniFiles.close() then MiniFiles.open() end
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
  },

  {
    "echasnovski/mini.ai",
    version = false, -- Main branch

    opts = {
      custom_textobjects = {
        -- Disable built-in text objects
        ["("] = false,
        ["["] = false,
        ["{"] = false,
        ["<"] = false,
        [")"] = false,
        ["]"] = false,
        ["}"] = false,
        [">"] = false,
        b = false,
        ['"'] = false,
        ["'"] = false,
        ["`"] = false,
        t = false,
        f = false, -- See treesitter text objects
        a = false, -- See vim-textobj-parameter
      },
    },
  },
}
