return {
  {
    LazyDep("tabby"),
    optional = true,

    opts = {
      option = {
        tab_name = {
          _my_overrides = {
            function(tab_id) return vim.t[tab_id].my_project_title end,
          },
        },
      },
    },
  },

  {
    LazyDep("workspaces"),
    lazy = false, -- Needed for `auto_open`

    opts = {
      cd_type = "tab",
      auto_open = true, -- Does not work if nvim launched with arguments

      hooks = {
        open = {
          function(name, path)
            vim.t.my_project_title = name
            vim.cmd.edit(path)
          end,
        },
      },
    },
  },
}
