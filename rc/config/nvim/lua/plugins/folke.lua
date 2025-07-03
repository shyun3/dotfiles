local lazygit_timer

return {
  {
    "folke/snacks.nvim",

    opts = {
      lazygit = {
        theme = {
          activeBorderColor = { fg = "Character", bold = true },
          searchingActiveBorderColor = { fg = "IncSearch", bold = true },
        },
        win = {
          style = "lazygit",

          -- Disable <Esc> twice quickly to enter normal mode
          -- Derived from https://github.com/folke/snacks.nvim/issues/280#issuecomment-2987923844
          keys = { term_normal = false },

          -- For some reason, the `WinEnter` event doesn't fire when exiting
          -- the lazygit window and re-entering the previous one. This is being
          -- manually fired here because there may be some custom autocommands
          -- that depend on it.
          on_close = function()
            lazygit_timer = vim.uv.new_timer()
            lazygit_timer:start(20, 0, function()
              lazygit_timer:stop()
              lazygit_timer:close()
              vim.schedule(
                function() vim.api.nvim_exec_autocmds("WinEnter", {}) end
              )
            end)
          end,
        },
      },
    },

    keys = {
      {
        "<Leader>lg",
        function()
          -- Using module instead of `Snacks` to avoid undefined global
          require("snacks").lazygit()
        end,
        desc = "Open lazygit",
      },
    },
  },

  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    event = "VeryLazy",

    opts = {
      lsp = {
        -- override markdown rendering so that plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },

      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search

        -- position the cmdline and popupmenu together
        -- blink should already do this
        command_palette = false,

        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },

    keys = {
      -- Lsp Hover Doc Scrolling
      -- Derived from https://github.com/folke/noice.nvim?tab=readme-ov-file#lsp-hover-doc-scrolling
      {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<C-f>" end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
      },
      {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<C-b>" end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
      },

      {
        "<C-s>",

        -- Derived from https://github.com/folke/noice.nvim/issues/341#issuecomment-2014613710
        function()
          local docs = require("noice.lsp.docs")
          local msg = docs.get("signature")
          if msg:win() then
            docs.hide(msg)
          else
            vim.lsp.buf.signature_help()
          end
        end,

        mode = { "n", "i", "s" },
        desc = "LSP: Toggle signature help",
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

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
