--- Notifies user of all renames that occurred
---
--- Derived from inc-rename.nvim
---
--- @param changes WorkspaceChanges
local function notify_renames(changes)
  local instances = 0
  local files = 0

  for _, edits in pairs(changes) do
    instances = instances + #edits
    files = files + 1
  end

  local message = string.format(
    "Renamed %s instance%s in %s file%s",
    instances,
    instances == 1 and "" or "s",
    files,
    files == 1 and "" or "s"
  )
  vim.notify(message)
end

--- Saves the given files, skipping the current buffer
---
--- @param result table WorkspaceEdit
local function save_other_changes(result)
  local changes = require("util.lsp").parse_workspace_edit(result)
  notify_renames(changes)

  local total_files = vim.tbl_count(changes)
  if total_files <= 1 then return end

  local saved_files = 0
  for uri, _ in pairs(changes) do
    local file = vim.uri_to_fname(uri)
    if file == uri then
      vim.notify("Could not save URI: " .. uri, vim.log.levels.WARN)
      goto continue
    end

    local buf_id = vim.uri_to_bufnr(uri)
    if vim.fn.bufnr() == buf_id then goto continue end

    local ok, err = vim.api.nvim_buf_call(
      buf_id,
      function() return pcall(vim.cmd.write) end
    )
    if ok then
      saved_files = saved_files + 1
    else
      vim.notify(
        "Could not save file: " .. file .. "\n\n" .. err,
        vim.log.levels.WARN
      )
    end
    ::continue::
  end

  local msg = string.format(
    "Saved %d/%d files modified due to renames (skipped current)",
    saved_files,
    total_files
  )
  vim.notify(msg)
end

-- Dummy function that replicates default 'tagfunc'
function _G.default_tagfunc()
  -- If tagfunc returns nil, standard tag lookup is performed
  -- See `tag-function`
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Taken from LazyVim

    init = function()
      -- Set 'tagfunc' to prevent LSP tagfunc from being assigned
      -- See `lsp-defaults`
      vim.o.tagfunc = "v:lua.default_tagfunc"

      -- Some LSP servers, like clangd, send all log messages to stderr. Neovim
      -- saves these as ERROR messages, even though they may be harmless.
      --
      -- Disable LSP logging to prevent the log file from becoming excessive.
      -- (Logging may be re-enabled as needed.)
      --
      -- See also `lsp-log`
      vim.lsp.set_log_level("off")
    end,

    keys = {
      {
        "<Leader>ri",
        vim.lsp.buf.incoming_calls,
        desc = "LSP: Incoming calls",
      },
      {
        "<Leader>ro",
        vim.lsp.buf.outgoing_calls,
        desc = "LSP: Outgoing calls",
      },

      {
        "<Leader>gd",

        function()
          local diag = vim.diagnostic.get(0)
          local qf = vim.diagnostic.toqflist(diag)
          vim.fn.setqflist({}, " ", {
            items = qf,
            title = "Buffer Diagnostics",
            nr = "$",
          })
          vim.cmd("botright copen")
        end,

        desc = "LSP: Buffer diagnostics",
      },

      {
        "<Leader>ch",

        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,

        desc = "LSP: Toggle inlay hints",
      },

      {
        "grn",
        function() require("util.lsp").rename(save_other_changes) end,
        desc = "LSP: Rename",
      },
    },
  },

  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",

    opts = {
      autocmd = {
        enabled = true,
        updatetime = -1,
        events = { "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" },
      },
    },
  },

  {
    "rmagatti/goto-preview",
    dependencies = "rmagatti/logger.nvim",
    event = "BufEnter",

    opts = {
      default_mappings = true,
      references = { provider = "fzf_lua" },
      vim_ui_input = false, -- Handled by noice

      post_open_hook = function(_, win)
        -- Fix highlights in floating windows
        -- Derived from #64
        vim.api.nvim_set_option_value("winhighlight", "Normal:", { win = win })
      end,
    },
  },
}
