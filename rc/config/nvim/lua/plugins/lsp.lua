--- Notifies user of all renames that occurred
---
--- Derived from inc-rename.nvim
---
---@param result table `result` key of an lsp-response
local function notify_renames(result)
  local instances = 0
  local files = 0

  local with_edits = result.documentChanges ~= nil
  for _, change in pairs(result.documentChanges or result.changes) do
    instances = instances + (with_edits and #(change.edits or {}) or #change)
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

--- Performs an LSP rename on the symbol under the cursor
---
--- Derived from inc-rename.nvim
---
---@param post_hook? fun(result: table) Callback that is run after changes are
--- applied. Takes a `result` key of an lsp-response.
local function rename(post_hook)
  local new_name
  vim.ui.input(
    { prompt = "New Name", default = vim.fn.expand("<cword>") },
    function(input) new_name = input end
  )
  if not new_name or new_name == "" then return end

  local method = "textDocument/rename"
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    method = method,
  })

  -- Only send request to first capable client
  local client = clients[1]
  if not client then
    vim.notify("No rename capable LSP client found", vim.log.levels.ERROR)
    return
  end

  local pos_params = vim.lsp.util.make_position_params(
    vim.api.nvim_get_current_win(),
    client.offset_encoding
  )
  local params = vim.tbl_extend("force", pos_params, { newName = new_name })

  client:request(method, params, function(err, result)
    if err then
      vim.notify("Error while renaming: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      vim.notify("No renames were performed", vim.log.levels.WARN)
      return
    end

    vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)

    notify_renames(result)
    if post_hook then post_hook(result) end
  end)
end

--- Saves the given files, if more than one is presented
---
--- @param result table `result` key of an `lsp-response`
local function save_multi_changes(result)
  local changes = result.documentChanges or result.changes
  local total_files = vim.tbl_count(changes)
  if total_files <= 1 then return end

  -- Assuming that noice is being used with notify enabled
  local record = vim.notify("Saving changes...")

  local saved_files = 0
  for uri, _ in pairs(changes) do
    local file = vim.uri_to_fname(uri)
    if file ~= uri then
      local ok, _ = pcall(vim.cmd.write, file)
      if ok then
        saved_files = saved_files + 1
      else
        vim.notify("Could not save file: " .. file, vim.log.levels.WARN)
      end
    else
      vim.notify("Could not save URI: " .. uri, vim.log.levels.WARN)
    end
  end

  local msg = saved_files == total_files and "Saved all changed files"
    or string.format("Saved %d/%d files", saved_files, total_files)
  vim.notify(msg, vim.log.levels.INFO, { replace = record and record.id })
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
        function() rename(save_multi_changes) end,
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
