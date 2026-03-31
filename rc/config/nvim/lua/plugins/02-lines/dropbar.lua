local HLGROUP_PREFIX = "MyDropBar"

local GROUP = vim.api.nvim_create_augroup("my_dropbar", {})

local function setup_file_icon_dim()
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  if not devicons_ok then return end

  local hl_map = {}
  for _, data in pairs(devicons.get_icons()) do
    local devicon_hlgroup = "DevIcon" .. data.name
    local hlgroup = HLGROUP_PREFIX .. devicon_hlgroup
    vim.api.nvim_set_hl(0, hlgroup, { link = devicon_hlgroup })

    hl_map[hlgroup] = "DropBarIconKindDefaultNC"
  end

  -- Derived from `dim()` in *dropbar/hlgroups.lua*
  vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
    group = GROUP,
    desc = "Dim file icon",

    callback = function()
      if vim.wo.winbar ~= "" then vim.opt_local.winhl:append(hl_map) end
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
    group = GROUP,
    desc = "Clear file icon dim",

    callback = function()
      if vim.wo.winbar ~= "" then
        vim.opt_local.winhl:remove(vim.tbl_keys(hl_map))
      end
    end,
  })
end

local function setup_focus_dim()
  local dropbar_group = "dropbar.hl"
  local dim_autocmds = vim.api.nvim_get_autocmds({
    group = dropbar_group,
    event = "WinLeave",
  })
  assert(#dim_autocmds == 1)

  vim.api.nvim_create_autocmd("FocusLost", {
    group = GROUP,
    desc = "Dim",
    callback = function(args)
      dim_autocmds[1].callback(args)

      if vim.wo.winbar ~= "" then
        -- Not all dropbar text elements have `DropBarKind*` highlight groups
        -- applied to them. By default, these seem to use `WinBar`. Neovim sets
        -- these to `WinBarNC` when switching windows, but not when focus is
        -- lost. So, do this manually.
        vim.opt_local.winhl:append({ WinBar = "WinBarNC" })
      end
    end,
  })

  local brighten_autocmds = vim.api.nvim_get_autocmds({
    group = dropbar_group,
    event = "WinEnter",
  })
  assert(#brighten_autocmds == 1)

  vim.api.nvim_create_autocmd("FocusGained", {
    group = GROUP,
    desc = "Clear dim",
    callback = function(args)
      brighten_autocmds[1].callback(args)
      if vim.wo.winbar ~= "" then vim.opt_local.winhl:remove("WinBar") end
    end,
  })
end

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
          -- Always show path
          return vim.api.nvim_buf_is_valid(buf)
            and vim.api.nvim_win_is_valid(win)
            and vim.fn.win_gettype(win) == ""
            and vim.wo[win].winbar == ""
            and vim.fn.bufname(buf) ~= ""
            and vim.bo[buf].buftype ~= "terminal"
            and vim.bo[buf].ft ~= "help"
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

      setup_file_icon_dim()
      setup_focus_dim()

      vim.api.nvim_create_autocmd("LspProgress", {
        group = GROUP,
        pattern = "end",
        desc = "Update dropbar",

        callback = function(args)
          vim.defer_fn(
            function()
              require("dropbar.utils").bar.exec("update", { buf = args.buf })
            end,
            require("dropbar.configs").opts.sources.lsp.request.interval + 50
          )
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
