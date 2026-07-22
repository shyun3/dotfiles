return {
  root_dir = function(bufnr, on_dir)
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    local buf_dir_name = vim.fs.dirname(buf_name)

    local find_root = require("lspconfig.util").root_pattern(
      -- Taken from lspconfig root markers
      ".taplo.toml",
      "taplo.toml",
      ".git"
    )

    -- If root isn't found, fallback to current directory. This
    -- enables Taplo on standalone TOML files, see issue dotfiles#5.
    local dir = find_root(buf_dir_name) or buf_dir_name

    on_dir(dir)
  end,
}
