return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        { "<Leader>p", desc = "Project" },
      },
    },
  },

  {
    LazyDep("tabby"),
    optional = true,

    opts = {
      option = {
        tab_name = {
          _my_overrides = {
            function(buf_id)
              local root, _ = require("project").get_project_root(buf_id)

              -- The returned root should not end with slash
              if root then return vim.fn.fnamemodify(root, ":t") end
            end,
          },
        },
      },
    },
  },

  {
    LazyDep("project"),
    lazy = false, -- To detect project when nvim is opened with CLI arguments

    opts = {
      patterns = { ".git" },
      scope_chdir = "win",
      show_hidden = true,
    },

    keys = {
      { "<Leader>pp", "<Cmd>Project<CR>", desc = "Menu" },
      { "<Leader>pa", "<Cmd>ProjectAdd<CR>", desc = "Add" },
    },
  },
}
