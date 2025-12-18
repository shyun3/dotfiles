---@alias OptionOp "on" | "off" | "toggle"
---@alias OptionOpDescs table<OptionOp, string>

---@type table<OptionOp, string[]>
local option_ops = {
  on = { "[o", "<s" },
  off = { "]o", ">s" },
  toggle = { "=s" },
}

---@type OptionOpDescs
local option_op_descs = {
  on = "Enable option",
  off = "Disable option",
  toggle = "Toggle option",
}

---@type table<string, string | OptionOpDescs>
local option_descs = {
  b = {
    on = "'background' (light)",
    off = "'background' (dark)",
    toggle = "'background' (dark is off, light is on)",
  },
  c = "'cursorline'",
  d = {
    on = "'diff' (actually :diffthis)",
    off = "'diff' (actually :diffoff)",
    toggle = "'diff' (actually :diffthis / :diffoff)",
  },
  h = "'hlsearch'",
  i = "'ignorecase'",
  l = "'list'",
  n = "'number'",
  p = {
    on = "Insert above with 'paste' set",
    off = "Insert below with 'paste' set",
    toggle = "Clear line and enter insert with 'paste' set",
  },
  r = "'relativenumber'",
  s = "'spell'",
  t = {
    on = "'colorcolumn' (+1 or last used value)",
    off = "'colorcolumn'",
    toggle = "'colorcolumn'",
  },
  u = "'cursorcolumn'",
  v = "'virtualedit'",
  w = "'wrap'",
  x = "'cursorline' and 'cursorcolumn'",

  ["<Esc>"] = "Cancel",
}

return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = function(_, opts)
      if opts.spec == nil then opts.spec = {} end

      local specs = {
        {
          "[n",
          mode = { "n", "x", "o" },
          desc = "Previous SCM conflict marker or hunk",
        },
        {
          "]n",
          mode = { "n", "x", "o" },
          desc = "Next SCM conflict marker or hunk",
        },

        { "[e", mode = { "n", "x" }, desc = "Exchange line with above" },
        { "]e", mode = { "n", "x" }, desc = "Exchange line with below" },

        { "<p", desc = "Paste after linewise, decreasing indent" },
        { ">p", desc = "Paste after linewise, increasing indent" },
        { "<P", desc = "Paste before linewise, decreasing indent" },
        { ">P", desc = "Paste before linewise, increasing indent" },
        { "=p", desc = "Paste after linewise, reindenting" },
        { "=P", desc = "Paste before linewise, reindenting" },

        { "[p", desc = "Paste before linewise, indent to line" },
        { "]p", desc = "Paste after linewise, indent to line" },
        { "[P", desc = "Paste before linewise, indent to line" },
        { "]P", desc = "Paste after linewise, indent to line" },

        { "[x", mode = { "n", "x" }, desc = "XML encode" },
        { "[xx", desc = "XML encode line" },
        { "]x", mode = { "n", "x" }, desc = "XML decode" },
        { "]xx", desc = "XML decode line" },

        { "[u", mode = { "n", "x" }, desc = "URL encode" },
        { "[uu", desc = "URL encode line" },
        { "]u", mode = { "n", "x" }, desc = "URL decode" },
        { "]uu", desc = "URL decode line" },

        { "[y", mode = { "n", "x" }, desc = "C String encode" },
        { "[yy", desc = "C String encode line" },
        { "[C", mode = { "n", "x" }, desc = "C String encode" },
        { "[CC", desc = "C String encode line" },
        { "]y", mode = { "n", "x" }, desc = "C String decode" },
        { "]yy", desc = "C String decode line" },
        { "]C", mode = { "n", "x" }, desc = "C String decode" },
        { "]CC", desc = "C String decode line" },
      }
      vim.list_extend(opts.spec, specs)

      for op, prefixes in pairs(option_ops) do
        for _, prefix in pairs(prefixes) do
          table.insert(opts.spec, { prefix, desc = option_op_descs[op] })

          for suffix, descs in pairs(option_descs) do
            local desc = type(descs) == "string" and descs or descs[op]
            table.insert(opts.spec, { prefix .. suffix, desc = desc })
          end
        end
      end
    end,
  },

  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    "tpope/vim-unimpaired",
    event = "VeryLazy",

    config = function()
      -- Doesn't interact well with which-key
      vim.keymap.del("n", "yo")
      vim.keymap.del("n", "yo<Esc>")
    end,

    keys = {
      -- which-key specs seem to apply unconditionally, so filetype-specific
      -- descriptions are defined here. Note how the RHS is also specified
      -- otherwise the description won't be applied.
      {
        "[f",
        "<Plug>(unimpaired-directory-previous)",
        ft = "qf",
        desc = "Older error list",
      },
      {
        "]f",
        "<Plug>(unimpaired-directory-next)",
        ft = "qf",
        desc = "Newer error list",
      },

      {
        "[f",
        "<Plug>(unimpaired-directory-previous)",
        desc = "Previous file",
      },
      {
        "]f",
        "<Plug>(unimpaired-directory-next)",
        desc = "Next file",
      },
    },
  },
}
