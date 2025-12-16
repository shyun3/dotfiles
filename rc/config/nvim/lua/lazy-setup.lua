-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end

  -- Derived from https://github.com/folke/lazy.nvim/issues/287#issuecomment-1370876298
  local lock_file = io.open(vim.fn.stdpath("config") .. "/lazy-lock.json", "r")
  if lock_file then
    local lock_data = lock_file:read("*a")
    local lazy_lock = vim.json.decode(lock_data)
    vim.fn.system({
      "git",
      "-C",
      lazypath,
      "checkout",
      lazy_lock["lazy.nvim"].commit,
    })
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { colorscheme = { "default" } },

  performance = {
    rtp = {
      disabled_plugins = {
        "matchparen",
        LazyDep("oil") and "netrwPlugin",
      },
    },
  },
})

vim.keymap.set("n", "<Leader>lz", "<Cmd>Lazy<CR>")
vim.keymap.set("n", "<Leader>lp", "<Cmd>Lazy profile<CR>")
