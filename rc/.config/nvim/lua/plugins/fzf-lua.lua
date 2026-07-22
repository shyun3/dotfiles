local util = require("util")

-- Beware not to share an options table across different picker calls, see
-- issue jjui#2612
local FD_OPTS_BASE = "--color=never --exclude .git --exclude .jj "
local FD_OPTS_FILES = FD_OPTS_BASE .. "--type f --type l"

local FILES_DIR_OPTS = {
  fd_opts = FD_OPTS_BASE .. "--type d",

  -- Derived from discussion fzf-lua#2591
  previewer = false,
  preview = {
    type = "cmd",
    fn = function(selected)
      local entry = require("fzf-lua.path").entry_to_file(selected[1])
      return string.format("tree -C %s", entry.path)
    end,
  },

  -- Same as default file picker actions but opening buffers using `:edit` et
  -- al. The default actions use lower level methods of opening selections
  -- which can interfere with directory plugin operations. See discussion
  -- fzf-lua#2608.
  actions = {
    default = {
      -- Derived from `actions.file_edit_or_qf`
      fn = function(selected, opts)
        if #selected > 1 then
          require("fzf-lua.actions").file_sel_to_qf(selected, opts)
        else
          local entry = require("fzf-lua.path").entry_to_file(selected[1], opts)
          vim.cmd.edit(entry.path)
        end
      end,

      desc = "dir-open-or-qf", -- F1 help
    },

    ["ctrl-s"] = {
      -- Derived from `actions.file_split`
      fn = function(selected, opts)
        for _, sel in ipairs(selected) do
          local entry = require("fzf-lua.path").entry_to_file(sel, opts)
          vim.cmd.split(entry.path)
        end
      end,

      desc = "dir-split",
    },

    ["ctrl-v"] = {
      -- Derived from `actions.file_vsplit`
      fn = function(selected, opts)
        for _, sel in ipairs(selected) do
          local entry = require("fzf-lua.path").entry_to_file(sel, opts)
          vim.cmd.vsplit(entry.path)
        end
      end,

      desc = "dir-vsplit",
    },

    ["ctrl-t"] = {
      -- Derived from `actions.file_tabedit`
      fn = function(selected, opts)
        for _, sel in ipairs(selected) do
          local entry = require("fzf-lua.path").entry_to_file(sel, opts)
          vim.cmd.tabnew(entry.path)
        end
      end,

      desc = "dir-tabedit",
    },
  },
}

return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        { "grs", desc = "Horizontal split" },
        { "grv", desc = "Vertical split" },
        { "<Leader>f", desc = "fzf-lua" },
        { "<Leader>s", desc = "Horizontal split" },
        { "<Leader>v", desc = "Vertical split" },
      },
    },
  },

  {
    LazyDep("goto-preview"),
    optional = true,

    opts = {
      references = { provider = "fzf_lua" },
    },
  },

  {
    LazyDep("mini.files"),
    optional = true,

    opts = {
      options = {
        -- While on opened directory, current window can get closed when
        -- launching fzf-lua
        use_as_default_explorer = false,
      },
    },
  },

  {
    LazyDep("oil"),
    optional = true,

    opts = {
      keymaps = {
        -- Remap preview key due to conflict with fzf-lua
        ["<C-p>"] = false,
        gp = "actions.preview",
      },
    },
  },

  {
    LazyDep("workspaces"),
    optional = true,

    keys = {
      {
        [[<A-\>]],

        -- Derived from workspaces.nvim#47 and project.nvim
        function()
          local fzf_lua = require("fzf-lua")
          local workspaces = require("workspaces")

          local sep = " \u{2192} " -- →
          local function contents(fzf_cb)
            for _, workspace in ipairs(workspaces.get()) do
              fzf_cb(workspace.name .. sep .. workspace.path)
            end
            fzf_cb()
          end

          local function split_selected(selected)
            local parts = vim.split(selected, sep)
            assert(#parts == 2, "Separator found in workspace name/path")
            return unpack(parts)
          end

          local opts = {
            winopts = { title = "Workspaces" },

            actions = {
              default = {
                fn = function(selected)
                  local name, _ = split_selected(selected[1])
                  workspaces.open(name)
                end,

                desc = "workspace-open", -- F1 help
              },

              ["ctrl-t"] = {
                -- See fzf-lua.core.set_header() for these key usages
                header = "open in new tab",
                desc = "workspace-tab-open",

                fn = function(selected)
                  local name, _ = split_selected(selected[1])
                  vim.cmd(
                    "tabedit | WorkspacesOpen " .. vim.fn.fnameescape(name)
                  )
                end,
              },

              ["ctrl-x"] = {
                header = "remove",
                desc = "workspace-remove",

                fn = function(selected)
                  for _, sel in ipairs(selected) do
                    local name, _ = split_selected(sel)
                    workspaces.remove(name)
                  end
                end,

                reload = true,
              },
            },

            preview = {
              type = "cmd",

              fn = function(items)
                local _, path = split_selected(items[1])
                return "tree -C " .. vim.fn.shellescape(path)
              end,
            },
          }

          fzf_lua.fzf_exec(contents, opts)
        end,

        desc = "Workspaces: Pick",
      },
    },
  },

  {
    "ibhagwan/fzf-lua",

    opts = {
      defaults = { header_separator = ", " },

      winopts = {
        preview = {
          default = "bat",
          layout = "vertical",
        },
      },

      oldfiles = {
        include_current_session = true,
        stat_file = false, -- Disabled for performance, see #1336
      },

      file_icon_padding = " ",
    },

    keys = {
      {
        "<Leader>fa",
        "<Cmd>FzfLua autocmds<CR>",
        desc = "Autocommands",
      },
      {
        "<Leader>fb",
        "<Cmd>FzfLua builtin<CR>",
        desc = "Built-in commands",
      },
      {
        "<Leader>fk",

        function()
          require("fzf-lua").keymaps({
            modes = { "n", "i", "c", "v", "o", "t" },
          })
        end,

        desc = "Keymaps",
      },

      {
        "<C-p>",

        function()
          util.go_to_editable_window()
          require("fzf-lua").files({ fd_opts = FD_OPTS_FILES })
        end,

        desc = "fzf-lua: Files",
      },
      {
        "<Leader><C-p>",

        function()
          util.go_to_editable_window()
          require("fzf-lua").files(FILES_DIR_OPTS)
        end,

        desc = "fzf-lua: Directories",
      },

      {
        "<C-q>",

        function()
          util.go_to_editable_window()

          require("fzf-lua").files({
            cwd = require("util.path").normalize(vim.fn.expand("%:p:h")),
            fd_opts = FD_OPTS_FILES,
          })
        end,

        desc = "fzf-lua: Files in current file directory",
      },
      {
        [[<C-\>]],

        function()
          util.go_to_editable_window()
          require("fzf-lua").buffers()
        end,

        desc = "fzf-lua: Buffers",
      },
      {
        "<A-p>",

        function()
          util.go_to_editable_window()
          require("fzf-lua").oldfiles()
        end,

        desc = "fzf-lua: Old files",
      },
      {
        "<A-h>",

        function()
          require("util").go_to_editable_window()
          require("fzf-lua").tags()
        end,

        desc = "fzf-lua: Tags",
      },
      {
        "<A-k>",

        function()
          -- `FzfLua btags` by default uses an existing tags file
          -- Generate the latest tags for the current file
          local filePath = vim.fn.expand("%")
          local tmp = vim.fn.tempname()
          vim.cmd({
            cmd = "!",
            args = { "ctags -f", tmp, string.format('"%s"', filePath) },
            mods = { silent = true },
          })

          -- Don't specify cwd for tags call if current file is not under cwd
          local cwd = filePath[1] ~= "/" and vim.fn.getcwd() or ""
          require("fzf-lua").btags({ ctags_file = tmp, cwd = cwd })
        end,

        desc = "fzf-lua: Buffer tags",
      },
      {
        "<C-j>",
        "<Cmd>FzfLua blines show_unlisted=true<CR>",
        desc = "fzf-lua: Current buffer lines",
      },
      {
        "<Leader>;",
        "<Cmd>FzfLua command_history<CR>",
        desc = "fzf-lua: Command history",
      },
      {
        "<Leader>/",
        "<Cmd>FzfLua search_history<CR>",
        desc = "fzf-lua: Search history",
      },
      {
        "<Leader>x",
        "<Cmd>FzfLua commands<CR>",
        desc = "fzf-lua: Neovim commands",
      },
      {
        "<Leader>cf",
        "<Cmd>FzfLua quickfix<CR>",
        desc = "fzf-lua: Quickfix list",
      },

      { "<Leader>hh", "<Cmd>FzfLua helptags<CR>", desc = "fzf-lua: Help tags" },
      {
        "<Leader>hl",
        "<Cmd>FzfLua highlights<CR>",
        desc = "fzf-lua: Highlight groups",
      },

      {
        "<Leader>]",
        "<Cmd>FzfLua lsp_definitions jump1=true<CR>",
        desc = "fzf-lua: LSP definitions",
      },
      {
        "<Leader>s]",

        function()
          require("fzf-lua").lsp_definitions({
            jump1 = true,
            jump1_action = require("fzf-lua.actions").file_split,
          })
        end,

        desc = "fzf-lua: LSP definitions",
      },
      {
        "<Leader>v]",

        function()
          require("fzf-lua").lsp_definitions({
            jump1 = true,
            jump1_action = require("fzf-lua.actions").file_vsplit,
          })
        end,

        desc = "fzf-lua: LSP definitions",
      },

      {
        "grt",
        "<Cmd>FzfLua lsp_typedefs jump1=true<CR>",
        desc = "fzf-lua: Type definitions",
      },
      {
        "grst",

        function()
          require("fzf-lua").lsp_typedefs({
            jump1 = true,
            jump1_action = require("fzf-lua.actions").file_split,
          })
        end,

        desc = "fzf-lua: Type definitions",
      },
      {
        "grvt",

        function()
          require("fzf-lua").lsp_typedefs({
            jump1 = true,
            jump1_action = require("fzf-lua.actions").file_vsplit,
          })
        end,

        desc = "fzf-lua: Type definitions",
      },

      {
        "<Leader>[",
        "<Cmd>FzfLua lsp_declarations jump1=true<CR>",
        desc = "fzf-lua: LSP declarations",
      },
      {
        "<Leader>s[",

        function()
          require("fzf-lua").lsp_declarations({
            jump1 = true,
            jump1_action = require("fzf-lua.actions").file_split,
          })
        end,

        desc = "fzf-lua: LSP declarations",
      },
      {
        "<Leader>v[",

        function()
          require("fzf-lua").lsp_declarations({
            jump1 = true,
            jump1_action = require("fzf-lua.actions").file_vsplit,
          })
        end,

        desc = "fzf-lua: LSP declarations",
      },

      {
        "<C-k>",
        "<Cmd>FzfLua lsp_document_symbols<CR>",
        desc = "fzf-lua: LSP document symbols",
      },
      {
        "<C-h>",

        function()
          util.go_to_editable_window()
          require("fzf-lua").lsp_workspace_symbols()
        end,

        desc = "fzf-lua: LSP workspace symbols",
      },

      {
        "gra",
        "<Cmd>FzfLua lsp_code_actions silent=true<CR>",
        mode = { "n", "x" },
        desc = "fzf-lua: LSP code actions",
      },
    },
  },
}
