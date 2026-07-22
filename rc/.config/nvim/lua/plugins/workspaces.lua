return {
  {
    LazyDep("tabby"),
    optional = true,

    opts = {
      option = {
        tab_name = {
          _my_overrides = {
            workspaces = function(tab_id) return vim.t[tab_id].my_project_title end,
          },
        },
      },
    },
  },

  {
    LazyDep("snacks"),
    optional = true,

    opts = {
      dashboard = {
        preset = {
          keys = {
            -- Derived from defaults
            { icon = " ", key = "n", desc = "New File", action = ":enew" },
            {
              icon = "󰒲 ",
              key = "L",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":q" },
          },
        },

        formats = {
          -- Derived from default
          file = function(item, ctx)
            local name = item.file
            if #name > ctx.width then
              name = "…" .. name:sub(-(ctx.width - 1))
            end

            return { { name, hl = "file" } }
          end,
        },

        -- Derived from `compact_files` example
        sections = {
          { section = "header" },
          {
            icon = " ",
            title = "Keymaps",
            section = "keys",
            indent = 2,
            padding = 1,
          },

          -- Action is cleared if projects section has title, so create
          -- separate title section. See snacks.nvim#411.
          {
            icon = " ",
            title = "Recent Projects",
          },
          {
            section = "projects",
            indent = 2,
            padding = 1,

            limit = 10,

            dirs = function()
              return vim.tbl_map(
                function(space) return space.name end,
                require("workspaces").get()
              )
            end,

            action = function(name) require("workspaces").open(name) end,
          },

          { section = "startup" },
        },
      },
    },
  },

  {
    LazyDep("workspaces"),
    lazy = false, -- Needed for `auto_open`

    opts = {
      cd_type = "tab",

      -- Doesn't interact well with lazy.nvim when installing plugins on startup
      auto_open = false,

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
