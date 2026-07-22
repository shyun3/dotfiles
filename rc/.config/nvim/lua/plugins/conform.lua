return {
  LazyDep("conform"),

  -- Derived from lazy loading recipe
  event = "BufWritePre",
  cmd = { "AutoFormatDisable", "AutoFormatEnable", "ConformInfo", "Format" },

  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,

  opts = {
    default_format_opts = { lsp_format = "fallback" },

    -- LSP is preferred since it can reduce dependencies. Neovim may also send
    -- relevant editor settings to the LSP, see `:h vim.lsp.buf.format()`.
    formatters_by_ft = {
      json = { "prettier" },
      jsonc = { "prettier" },

      meson = {
        -- Default formatting doesn't seem to match `meson format`
        -- See mesonlsp#198
        "meson",
      },

      python = { "isort", "black" },

      sh = {
        -- bash-language-server doesn't support `shfmt` EditorConfig extensions
        -- See bash-language-server#1351
        "shfmt",
      },

      zsh = { "shfmt" },
    },

    -- Derived from recipe
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000 }
    end,
  },

  config = function(_, opts)
    require("conform").setup(opts)

    -- Command to run async formatting, derived from recipes
    -- Names of formatters to run can be passed as arguments
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
        range = range,
        formatters = #args.fargs > 0 and args.fargs or nil,
      })
    end, {
      desc = "Format buffer",
      range = true,
      nargs = "*",

      complete = function()
        local formatters = require("conform").list_all_formatters()
        return vim.tbl_map(function(info) return info.name end, formatters)
      end,
    })

    -- Commands to enable/disable autoformatting, derived from recipe
    vim.api.nvim_create_user_command("AutoFormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("AutoFormatEnable", function(args)
      vim.b.disable_autoformat = false
      if not args.bang then vim.g.disable_autoformat = false end
    end, { desc = "Re-enable autoformat-on-save", bang = true })
  end,
}
