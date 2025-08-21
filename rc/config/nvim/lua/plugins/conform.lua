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
      query = { "format-queries" },
      sh = { "shfmt" },
      toml = { "tombi" },
      yaml = { "prettier" },
    },

    formatters = {
      ["meson-format"] = function(bufnr)
        return {
          command = "meson",
          args = {
            "format",
            "--source-file-path", -- Added in v1.9.0
            vim.api.nvim_buf_get_name(bufnr),
            "-",
          },
        }
      end,
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

  init = function()
    vim.o.formatexpr =
      "v:lua.require'conform'.formatexpr({'lsp_format': 'never'})"
  end,

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
      require("conform").format({ async = true, range = range })
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
    vim.api.nvim_create_user_command("AutoFormatEnable", function(args)
      vim.b.disable_autoformat = false
      if not args.bang then vim.g.disable_autoformat = false end
    end, { desc = "Re-enable autoformat-on-save", bang = true })
  end,

  -- Derived from lazy loading recipe
  event = "BufWritePre",
  cmd = { "AutoFormatDisable", "AutoFormatEnable", "ConformInfo", "Format" },
}
