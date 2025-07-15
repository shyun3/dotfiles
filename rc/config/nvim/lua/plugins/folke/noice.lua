return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  event = "VeryLazy",

  opts = {
    cmdline = {
      format = {
        -- Not concealing helps with aligning the pop-up menu to the cursor
        cmdline = { conceal = false },
        search_down = { conceal = false },
        search_up = { conceal = false },
        filter = { conceal = false },
        lua = { conceal = false },
        help = { conceal = false },
        input = { conceal = false },
      },
    },

    lsp = {
      -- override markdown rendering so that plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },

    routes = {
      -- Show @recording messages
      -- Taken from https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
      {
        view = "notify",
        filter = { event = "msg_showmode" },
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
}
