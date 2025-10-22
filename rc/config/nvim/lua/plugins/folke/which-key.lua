return {
  require("lazy-deps").which_key,
  event = "VeryLazy",

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

      -- Visual mode
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

      -- Close windows
      { "<Leader>q", desc = "Close window" },
      {
        "<Leader>qq",
        "<Cmd>cclose<CR>",
        desc = "Quickfix",
      },
      {
        "<Leader>qh",
        "<Cmd>helpclose<CR>",
        desc = "Help",
      },
    },

    triggers = {
      -- Default must be specified if customizing triggers
      { "<auto>", mode = "nixsotc" },
    },
  },

  config = function(_, opts)
    require("which-key").setup(opts)

    for _, mode in pairs({ "i", "s", "x", "c", "o" }) do
      vim.keymap.set(
        mode,
        "<C-q>",
        function() require("which-key").show({ mode = mode }) end,
        { desc = "which-key: Show mappings" }
      )
    end
  end,

  keys = {
    { "<Leader>?", "<Cmd>WhichKey<CR>", desc = "which-key: Show mappings" },
    { "<C-q>", mode = { "i", "v", "c", "o" } },
  },
}
