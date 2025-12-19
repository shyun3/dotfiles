return {
  {
    LazyDep("vim-grepper"),
    optional = true,

    keys = {
      {
        "<Leader><Leader>",
        function() vim.cmd("Grepper -cd " .. require("oil").get_current_dir()) end,
        ft = "oil",
        desc = "Grepper (force current Oil directory)",
      },
    },
  },

  {
    LazyDep("oil"),
    event = "UIEnter",

    init = function()
      -- Although oil can disable netrw when it loads, the latter must be
      -- disabled on startup to prevent netrw usage when loading oil late and
      -- opening a folder directly as a CLI argument
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,

    opts = {
      keymaps = {
        ["<C-p>"] = false, -- Conflicts with fzf-lua
        gp = "actions.preview",
      },
    },
  },
}
