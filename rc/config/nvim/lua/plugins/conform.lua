-- Derived from https://www.vikasraj.dev/blog/vim-dot-repeat
-- Does not support count, visual blocks, or dot repeat for visuals
function _G.format_range_operator(motion)
  local visual = string.match(motion or "", "[vV]")
  if not visual and motion == nil then
    vim.o.operatorfunc = "v:lua.format_range_operator"
    return "g@"
  end

  local range = {
    starting = vim.api.nvim_buf_get_mark(0, visual and "<" or "["),
    ending = vim.api.nvim_buf_get_mark(0, visual and ">" or "]"),
  }
  if motion == "V" then
    -- Use line length instead of v:maxcol (which causes error)
    range.ending[2] = vim.fn.col({ range.ending[1], "$" })
  end

  require("conform").format({
    async = true,
    lsp_fallback = true,
    range = {
      start = range.starting,
      ["end"] = range.ending,
    },
  })
end

return {
  "stevearc/conform.nvim",

  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      json = { "prettier" },
      jsonc = { "prettier" },
      lua = { "stylua" },
      meson = { "meson-format" },
      python = { "isort", "black" },
      sh = { "shfmt" },
      yaml = { "prettier" },
    },

    formatters = {
      ["meson-format"] = {
        command = "meson",
        args = { "format", "-" },
      },
    },

    -- Derived from recipe
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_fallback = true, quiet = true }
    end,
  },

  config = function(_, opts)
    require("conform").setup(opts)

    -- Force prettier to parse certain filetypes
    require("conform.formatters").prettier.options.ft_parsers = {
      -- Otherwise, .clangd and others cannot be parsed
      yaml = "yaml",
    }

    -- Command to run async formatting, taken from recipes
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line =
          vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({
        async = true,
        lsp_fallback = true,
        range = range,
      })
    end, { desc = "Format buffer", range = true })

    -- Commands to enable/disable autoformatting, derived from recipe
    vim.api.nvim_create_user_command("AutoFormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })
    vim.api.nvim_create_user_command("AutoFormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })
  end,

  -- Derived from lazy loading recipe
  event = "BufWritePre",
  cmd = { "AutoFormatDisable", "AutoFormatEnable", "ConformInfo", "Format" },

  keys = {
    {
      "<Leader>gf",
      _G.format_range_operator,
      mode = "n",
      desc = "Format selection",
      silent = true,
      expr = true,
    },
    {
      "<Leader>gf",
      "<Esc><Cmd>lua _G.format_range_operator(vim.fn.visualmode())<CR>",
      mode = "x",
      desc = "Format selection",
      silent = true,
    },
  },
}
