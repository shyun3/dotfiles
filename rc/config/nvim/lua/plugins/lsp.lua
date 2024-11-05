local function on_lsp_attach(client, bufnr)
  -- Derived from `:h lsp-defaults-disable`
  vim.bo.tagfunc = ""

  if client.name == "lua_ls" then
    -- Derived from `:h vim.lsp.semantic_tokens.start()`
    client.server_capabilities.semanticTokensProvider = nil
  end

  if client.server_capabilities.signatureHelpProvider then
    ---@diagnostic disable-next-line: missing-fields
    require("lsp-overloads").setup(client, {
      ---@diagnostic disable-next-line: missing-fields
      ui = { floating_window_above_cur_line = true },
      keymaps = {
        next_signature = "<C-n>",
        previous_signature = "<C-p>",
        next_parameter = "<C-l>",
        previous_parameter = "<C-h>",
        close_signature = "<C-s>",
      },
      display_automatically = false,
    })

    vim.keymap.set(
      { "n", "i", "v" },
      "<C-s>",
      "<Cmd>LspOverloadsSignature<CR>",
      { silent = true, buffer = bufnr }
    )
  end
end

return {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "Issafalcon/lsp-overloads.nvim",
    },

    config = function()
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = on_lsp_attach,
          })
        end,
      })
    end,

    keys = {
      { "<Leader>rr", vim.lsp.buf.references, desc = "LSP: References" },
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
          vim.fn.setqflist(qf)
          vim.cmd("botright copen")
        end,

        desc = "LSP: Buffer diagnostics",
      },

      { "<Leader>ca", vim.lsp.buf.code_action, desc = "LSP: Code action" },
      { "<Leader>rn", vim.lsp.buf.rename, desc = "LSP: Rename" },

      {
        "<Leader>ch",

        function()
          ---@diagnostic disable-next-line: missing-parameter
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,

        desc = "LSP: Toggle inlay hints",
      },
    },
  },

  {
    "folke/lazydev.nvim",
    dependencies = { "Bilal2453/luvit-meta" },
    ft = "lua",

    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "j-hui/fidget.nvim", opts = {} },
}
