return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        { "<Leader>gc", desc = "Git conflicts" },
        { "<Leader>gcd", desc = "Diff" },
      },
    },
  },

  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        resolve = {
          -- Disable section highlights
          ResolveOursSection = { link = "NONE" },
          ResolveTheirsSection = { link = "NONE" },
          ResolveAncestorSection = { link = "NONE" },

          ResolveOursMarker = { link = "DiffDelete" },
          ResolveTheirsMarker = { link = "DiffAdd" },
          ResolveSeparatorMarker = { link = "DiffChange" },
          ResolveAncestorMarker = { link = "DiffText" },
        },
      },
    },
  },

  {
    "spacedentist/resolve.nvim",
    event = "BufReadPre",

    opts = { default_keymaps = false },

    keys = {
      { "<Leader>gco", "<Plug>(resolve-ours)", desc = "Choose ours" },
      { "<Leader>gct", "<Plug>(resolve-theirs)", desc = "Choose theirs" },
      {
        "<Leader>gcb",
        "<Plug>(resolve-both)",
        desc = "Choose ours then theirs",
      },
      {
        "<Leader>gcB",
        "<Plug>(resolve-both-reverse)",
        desc = "Choose theirs then ours",
      },
      { "<Leader>gcm", "<Plug>(resolve-base)", desc = "Choose base" },
      { "<Leader>gcn", "<Plug>(resolve-none)", desc = "Choose none" },
      { "<Leader>gcl", "<Plug>(resolve-list)", desc = "List" },

      { "<Leader>gcdo", "<Plug>(resolve-diff-ours)", desc = "Ours" },
      { "<Leader>gcdt", "<Plug>(resolve-diff-theirs)", desc = "Theirs" },
      { "<Leader>gcdb", "<Plug>(resolve-diff-both)", desc = "Both" },
      { "<Leader>gcdv", "<Plug>(resolve-diff-vs)", desc = "Ours → Theirs" },
      {
        "<Leader>gcdV",
        "<Plug>(resolve-diff-vs-reverse)",
        desc = "Theirs → Ours",
      },
    },
  },
}
