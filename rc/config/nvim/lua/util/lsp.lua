--- @alias WorkspaceChanges table<string, table> # DocumentUri to TextEdit[]

local M = {}

--- Parses a WorkspaceEdit object into a common form
---
--- @param result table WorkspaceEdit
---
--- @return WorkspaceChanges
function M.parse_workspace_edit(result)
  local changes = {}
  if result.documentChanges then
    for _, doc in pairs(result.documentChanges) do
      changes[doc.textDocument.uri] = vim.deepcopy(doc.edits)
    end
  elseif result.changes then
    for uri, edit in pairs(result.changes) do
      changes[uri] = vim.deepcopy(edit)
    end
  end

  return changes
end

--- Performs an LSP rename on the symbol under the cursor
---
--- Derived from inc-rename.nvim
---
---@param post_hook? fun(result: table) Callback that is run after changes are
--- applied. Takes a WorkspaceEdit.
function M.rename(post_hook)
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
    if post_hook then post_hook(result) end
  end)
end

return M
