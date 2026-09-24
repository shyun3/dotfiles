return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        -- Disable cargo check diagnostics, since that only runs on save
        command = "",
      },
      diagnostics = {
        experimental = { enable = true },
      },
    },
  },
}
