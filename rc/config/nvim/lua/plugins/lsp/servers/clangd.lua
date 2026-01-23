return {
  LazyDep("mason-lspconfig"),
  optional = true,

  opts = {
    ensure_installed = { "clangd" },
  },
}
