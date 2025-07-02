local function on_lsp_attach(client)
  -- Make tag commands only operate on tags, not LSP
  -- Derived from `:h lsp-defaults-disable`
  vim.bo.tagfunc = ""

  if client.name == "lua_ls" then
    -- Derived from `:h vim.lsp.semantic_tokens.start()`
    client.server_capabilities.semanticTokensProvider = nil
  end
end

return {
  {
    "neovim/nvim-lspconfig",

    config = function()
      -- This is not being included in a wildcard config as `on_attach` because
      -- it would get overriden by any LSP configs provided later
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then on_lsp_attach(client) end
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
          vim.fn.setqflist({}, " ", {
            items = qf,
            title = "Buffer Diagnostics",

            ---@diagnostic disable-next-line: assign-type-mismatch
            nr = "$",
          })
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

      {
        "<C-s>",

        -- Already mapped by default for insert mode, see `lsp-defaults`
        function() vim.lsp.buf.signature_help() end,

        desc = "LSP: Signature help",
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

  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = "LspAttach",

    opts = {
      symbol_in_winbar = { folder_level = 0 },
      lightbulb = { virtual_text = false },
      beacon = { enable = false },

      rename = { auto_save = true, keys = { quit = "<A-c>" } },
    },

    keys = {
      { "<Leader>f]", "<Cmd>Lspsaga peek_definition<CR>" },
      { "<Leader>fD", "<Cmd>Lspsaga peek_type_definition<CR>" },

      { "<Leader>o", "<Cmd>Lspsaga outline<CR>" },
      { "grn", "<Cmd>Lspsaga rename<CR>" },
    },
  },
}
