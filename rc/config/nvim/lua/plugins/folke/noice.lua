return {
  { "MunifTanjim/nui.nvim", lazy = true },
  { "rcarriga/nvim-notify", lazy = true, opts = { stages = "slide" } },

  {
    "folke/noice.nvim",
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

        -- Suppress hop prompts
        {
          filter = { kind = "echo", find = "^Hop [^:]+: " },
          opts = { skip = true },
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

    config = function(_, opts)
      require("noice").setup(opts)

      require("which-key").add({
        { "<Leader>n", desc = "Noice" },
      })
    end,

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
        desc = "Scroll forward (page or LSP hover/signature)",
      },
      {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<C-b>" end
        end,
        mode = { "n", "i", "s" },
        silent = true,
        expr = true,
        desc = "Scroll backward (page or LSP hover/signature)",
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

      { "<Leader>nh", "<Cmd>Noice<CR>", desc = "Show message history" },
      { "<Leader>nl", "<Cmd>NoiceLast<CR>", desc = "Show last message" },
      {
        "<Leader>nd",
        "<Cmd>NoiceDismiss<CR>",
        desc = "Dismiss all visible messages",
      },
      { "<Leader>ne", "<Cmd>NoiceErrors<CR>", desc = "Show error messages" },
      { "<Leader>na", "<Cmd>NoiceAll<CR>", desc = "Show all messages" },
      { "<Leader>np", "<Cmd>NoicePick<CR>", desc = "Open picker" },
    },
  },
}
