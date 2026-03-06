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

    cmd = {
      "WorkspacesAdd",
      "WorkspacesAddDir",
      "WorkspacesRemove",
      "WorkspacesRemoveDir",
      "WorkspacesRename",
      "WorkspacesList",
      "WorkspacesListDirs",
      "WorkspacesOpen",
      "WorkspacesSyncDirs",
    },

    opts = {
      cd_type = "tab",

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
