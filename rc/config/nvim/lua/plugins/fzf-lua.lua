local util = require("util")

local FD_OPTS_BASE = "--color=never --exclude .git --exclude .jj "

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
    "ibhagwan/fzf-lua",

    opts = {
      winopts = {
        preview = {
          default = "bat",
          layout = "vertical",
        },
      },

      oldfiles = {
        include_current_session = true,

        -- Disabled for performance, see #1336
        stat_file = false,
      },
      file_icon_padding = " ",
    },

    keys = {
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
          require("fzf-lua").files({
            fd_opts = FD_OPTS_BASE .. "--type f --type l",
          })
        end,

        desc = "fzf-lua: Files",
      },
      {
        "<Leader><C-p>",

        function()
          util.go_to_editable_window()
          require("fzf-lua").files({ fd_opts = FD_OPTS_BASE .. "--type d" })
        end,

        desc = "fzf-lua: Directories",
      },

      {
        "<C-q>",

        function()
          util.go_to_editable_window()
          require("fzf-lua").files({
            cwd = require("util.path").normalize(vim.fn.expand("%:p:h")),
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
