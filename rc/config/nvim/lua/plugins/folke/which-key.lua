return {
  {
    LazyDep("Comment"),
    optional = true,

    event = "VeryLazy", -- To load mapping descriptions for which-key
  },

  {
    LazyDep("nvim-surround"),
    optional = true,

    event = "VeryLazy", -- To load mapping descriptions for which-key
  },

  {
    LazyDep("which-key"),
    event = "VeryLazy",

    init = function()
      vim.o.timeoutlen = 500 -- To quickly trigger which-key
    end,

    opts_extend = { "spec", "triggers" },

    opts = {
      preset = "modern",

      spec = {
        { "u", desc = "Undo" },
        { "U", desc = "Undo all on latest line" },
        { "K", desc = "LSP: Hover" },
        { "Y", desc = "Yank to end of line" },
        { ".", desc = "Repeat" },
        { "&", desc = "Repeat last substitute with flags" },
        { "<C-l>", desc = "Clear and redraw screen" },
        { "<C-r>", desc = "Redo" },

        { "gh", desc = "Select mode" },
        { "gH", desc = "Linewise select mode" },
        { "g<C-h>", desc = "Blockwise select mode" },
        { "gq", mode = { "n", "x" }, desc = "Custom format lines" },
        { "gri", desc = "Implementations" },
        { "grr", desc = "References" },
        { "gO", desc = "Show outline" },

        { "[a", desc = "Edit previous file in argument list" },
        { "[b", desc = "Go to previous buffer in buffer list" },
        { "[l", desc = "Location: Display previous error" },
        { "[L", desc = "Location: Display first error" },
        { "[q", desc = "Quickfix: Display previous error" },
        { "[A", desc = "Edit first file in argument list" },
        { "[B", desc = "Go to first buffer in buffer list" },
        { "[Q", desc = "Quickfix: Display first error" },
        { "[t", desc = "Jump to previous matching tag" },
        { "[T", desc = "Jump to first matching tag" },
        { "[<C-l>", desc = "Location: Display last error in previous file" },
        { "[<C-q>", desc = "Quickfix: Display last error in previous file" },
        { "[<C-t>", desc = "Jump to previous matching tag in preview window" },

        { "]a", desc = "Edit next file in argument list" },
        { "]b", desc = "Go to next buffer in buffer list" },
        { "]l", desc = "Location: Display next error" },
        { "]L", desc = "Location: Display last error" },
        { "]A", desc = "Edit last file in argument list" },
        { "]B", desc = "Go to last buffer in buffer list" },
        { "]q", desc = "Quickfix: Display next error" },
        { "]Q", desc = "Quickfix: Display last error" },
        { "]t", desc = "Jump to next matching tag" },
        { "]T", desc = "Jump to last matching tag" },
        { "]<C-l>", desc = "Location: Display first error in next file" },
        { "]<C-q>", desc = "Quickfix: Display first error in next file" },
        { "]<C-t>", desc = "Jump to next matching tag in preview window" },

        -- Groups
        { "=", mode = { "n", "x" }, desc = "Reindent" },
        { "[", mode = { "n", "x", "o" }, desc = "Previous" },
        { "]", mode = { "n", "x", "o" }, desc = "Next" },
        { "<Leader>", mode = { "n", "x", "o" }, desc = "Leader" },

        -- Insert mode
        { "<C-u>", mode = "i", desc = "Delete characters before cursor" },
        { "<C-w>", mode = "i", desc = "Delete word before cursor" },

        -- Visual and operator-pending modes
        {
          "Q",
          mode = "x",
          desc = "Repeat last recorded register for each line (linewise only)",
        },
        {
          "@",
          mode = "x",
          desc = "Execute register contents for each line (linewise only)",
        },
        { "a%", mode = "x", desc = "Matching group" },
        { "<C-g>", mode = "x", desc = "Select mode" },
        {
          "g%",
          mode = { "o", "x" },
          desc = "Cycle backwards through matching groups",
        },
        { "[%", mode = { "o", "x" }, desc = "Previous unmatched group" },
        { "]%", mode = { "o", "x" }, desc = "Next unmatched group" },

        -- Select mode
        { "<C-g>", mode = "s", desc = "Visual mode" },

        -- Open tags in splits
        { "<A-]>", desc = "Tag" },
        {
          "<A-]>s",
          "<Cmd>wincmd g<C-]><CR>",
          desc = "Open definition in horizontal split",
        },
        {
          "<A-]>v",
          "<Cmd>vertical wincmd g<C-]><CR>",
          desc = "Open definition in vertical split",
        },

        -- Close
        { "<Leader>q", desc = "Close" },
        { "<Leader>qq", "<Cmd>cclose<CR>", desc = "Quickfix" },
        { "<Leader>qh", "<Cmd>helpclose<CR>", desc = "Help" },
        { "<Leader>qt", "<Cmd>tabclose<CR>", desc = "Tab" },
      },

      triggers = {
        -- Default must be specified if customizing triggers
        { "<auto>", mode = "nixsotc" },
      },
    },

    keys = function()
      local keys = {
        { "<Leader>?", "<Cmd>WhichKey<CR>", desc = "which-key: Show mappings" },
        {
          "<Leader>l?",
          function() require("which-key").show({ global = false }) end,
          desc = "which-key: Show buffer-local mappings",
        },
      }

      for _, mode in ipairs({ "i", "s", "x", "c", "o" }) do
        table.insert(keys, {
          "<C-q>",
          function() require("which-key").show({ mode = mode }) end,
          mode = mode,
          desc = "which-key: Show mappings",
        })
      end

      return keys
    end,
  },
}
