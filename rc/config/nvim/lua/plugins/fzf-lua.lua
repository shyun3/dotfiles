local util = require("util")

return {
  "ibhagwan/fzf-lua",

  opts = {
    winopts = {
      preview = {
        default = "bat",
        layout = "vertical",
      },
    },

    previewers = {
      bat = {
        -- Taken from https://github.com/ibhagwan/fzf-lua/issues/28#issuecomment-892216156
        config = nil,
      },
    },

    -- Git icons are disabled for performance reasons
    files = {
      git_icons = false,
    },
    oldfiles = {
      include_current_session = true,

      -- Disabled for performance, see #1336
      stat_file = false,
    },
    tags = {
      git_icons = false,
    },
    btags = {
      git_icons = false,
    },
    file_icon_padding = " ", -- En space, U+2002
  },

  config = function(_, opts)
    require("fzf-lua").setup(opts)

    require("which-key").add({
      { "grs", desc = "Horizontal split" },
      { "grv", desc = "Vertical split" },
      { "<Leader>s", desc = "Horizontal split" },
      { "<Leader>v", desc = "Vertical split" },
    })
  end,

  keys = {
    {
      "<C-p>",
      function()
        util.go_to_editable_window()
        require("fzf-lua").files({ cwd = vim.fn.getcwd() })
      end,
      desc = "fzf-lua: Files",
    },
    {
      "<C-q>",
      function()
        util.go_to_editable_window()
        require("fzf-lua").files({
          cwd = util.oil_filter(vim.fn.expand("%:p:h")),
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
      "<Leader>f",
      "<Cmd>FzfLua builtin<CR>",
      desc = "fzf-lua: Built-in commands",
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
      "grt", -- Overwrites default, see `lsp-defaults`
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
      "<Cmd> FzfLua lsp_code_actions silent=true<CR>",
      desc = "fzf-lua: LSP code actions",
    },
  },
}
