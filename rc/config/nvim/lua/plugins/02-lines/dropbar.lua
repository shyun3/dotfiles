local HLGROUP_PREFIX = "MyDropBar"

return {
  {
    LazyDep("catppuccin"),
    optional = true,

    opts = {
      _my_custom_highlights = {
        dropbar = {
          DropBarKindFile = { link = "Comment" },
          DropBarKindDir = { link = "Comment" },

          -- Must be different from WinBar for dimming to be enabled
          -- See dropbar/hlgroups.lua
          WinBarNC = { link = "Comment" },
        },
      },

      integrations = {
        dropbar = { color_mode = true },
      },
    },
  },

  {
    LazyDep("dropbar"),
    event = "UIEnter",

    opts = {
      bar = {
        -- Derived from default bar enable function
        enable = function(buf, win)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].winbar ~= ""
            or vim.fn.bufname(buf) == ""
            or vim.bo[buf].buftype == "terminal"
            or vim.bo[buf].ft == "help"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then return false end

          return true -- Always show path
        end,
      },

      icons = {
        ui = {
          bar = {
            separator = " › ", -- Taken from lspsaga
          },
        },

        kinds = {
          -- Derived from default
          file_icon = function(path)
            local icon_kind_opts = require("dropbar.configs").opts.icons.kinds
            local file_icon = icon_kind_opts.symbols.File
            local file_icon_hl = "DropBarIconKindFile"
            local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
            if not devicons_ok then return file_icon, file_icon_hl end

            -- Try to find icon using the filename, explicitly disable the
            -- default icon so that we can try to find the icon using the
            -- filetype if the filename does not have a corresponding icon
            local devicon, devicon_hl = devicons.get_icon(
              vim.fs.basename(path),
              vim.fn.fnamemodify(path, ":e"),
              { default = false }
            )

            -- No corresponding devicon found using the filename, try finding icon
            -- with filetype if the file is loaded as a buf in nvim
            if not devicon then
              ---@type integer?
              local buf = vim.iter(vim.api.nvim_list_bufs()):find(
                function(buf) return vim.api.nvim_buf_get_name(buf) == path end
              )
              if buf then
                local filetype =
                  vim.api.nvim_get_option_value("filetype", { buf = buf })
                devicon, devicon_hl = devicons.get_icon_by_filetype(filetype)
              end
            end

            file_icon = devicon and devicon .. " " or file_icon
            file_icon_hl = devicon_hl and HLGROUP_PREFIX .. devicon_hl

            return file_icon, file_icon_hl
          end,
        },
      },

      sources = { path = { max_depth = 2 } },
    },

    config = function(_, opts)
      require("dropbar").setup(opts)

      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      if not devicons_ok then return end

      local hl_map = {}
      for _, data in pairs(devicons.get_icons()) do
        local devicon_hlgroup = "DevIcon" .. data.name
        local hlgroup = HLGROUP_PREFIX .. devicon_hlgroup
        vim.api.nvim_set_hl(0, hlgroup, { link = devicon_hlgroup })

        hl_map[hlgroup] = "DropBarIconKindDefaultNC"
      end

      vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
        group = vim.api.nvim_create_augroup("my_dropbar", {}),
        desc = "Dim file icon",

        callback = function(args)
          if vim.wo.winbar == "" then return end

          -- Derived from `dim()` in *dropbar/hlgroups.lua*
          if args.event == "WinLeave" then
            vim.opt_local.winhl:append(hl_map)
          else
            vim.opt_local.winhl:remove(vim.tbl_keys(hl_map))
          end
        end,
      })
    end,

    keys = {
      {
        "[;",
        function() require("dropbar.api").goto_context_start() end,
        desc = "Go to start of current context",
      },
    },
  },
}
