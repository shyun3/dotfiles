local capabilities = vim.lsp.protocol.make_client_capabilities()

-- By default, `workspace/didChangeWatchedFiles` is disabled on Linux
-- See `:h lsp-defaults`
--
-- Enable it to add support for dynamic configuration
-- See https://docs.astral.sh/ruff/editors/features/#dynamic-configuration
capabilities.workspace =
  vim.tbl_deep_extend("force", capabilities.workspace or {}, {
    didChangeWatchedFiles = { dynamicRegistration = true },
  })

return { capabilities = capabilities }
