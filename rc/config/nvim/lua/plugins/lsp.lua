local function on_lsp_attach(client, bufnr)
  -- Make tag commands only operate on tags, not LSP
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
      "hrsh7th/cmp-nvim-lsp",
      "Issafalcon/lsp-overloads.nvim",
    },

    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- This is not being included in the config above as `on_attach` because
      -- it would get overriden by any LSP configs provided later
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then on_lsp_attach(client, args.buf) end
        end,
      })
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
          vim.fn.setqflist(qf)
          vim.cmd("botright copen")
        end,

        desc = "LSP: Buffer diagnostics",
      },

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
