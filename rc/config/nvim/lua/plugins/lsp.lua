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
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end,

        desc = "LSP: Toggle inlay hints",
      },
    },
  },

  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = "LspAttach",

    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = { enable = false },
      beacon = { enable = false },
    },

    keys = {
      { "<Leader>o", "<Cmd>Lspsaga outline<CR>" },
    },
  },

  {
    "smjonas/inc-rename.nvim",

    opts = {
      post_hook = function(result)
        for uri, _ in pairs(result.documentChanges or result.changes) do
          local file = vim.uri_to_fname(uri)
          if file ~= uri then
            vim.cmd.write(file)
          else
            vim.notify(
              string.format('Could not save "%s"', uri),
              vim.log.levels.WARN
            )
          end
        end
      end,
    },

    keys = {
      {
        "grn",
        function() return ":IncRename " .. vim.fn.expand("<cword>") end,
        desc = "IncRename",
        expr = true,
      },
    },
  },

  {
    "kosayoda/nvim-lightbulb",
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

      -- Derived from https://github.com/rmagatti/goto-preview/issues/64
      post_open_hook = function(_, win)
        vim.api.nvim_set_option_value("winhighlight", "Normal:", { win = win })
      end,
    },
  },
}
