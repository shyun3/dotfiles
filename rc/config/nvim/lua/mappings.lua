-- List tags before jumping if more than one match
vim.keymap.set({ "n", "v" }, "<C-]>", "g<C-]>")

-- Open tags in splits
vim.keymap.set("n", "<A-]>s", "<Cmd>wincmd g<C-]><CR>")
vim.keymap.set("n", "<A-]>v", "<Cmd>vertical wincmd g<C-]><CR>")

-- Buffers
vim.keymap.set("n", "<Leader><BS>", "<Cmd>bdelete<CR>")

-- Window navigation
vim.keymap.set("n", "]w", "<Cmd>wincmd w<CR>")
vim.keymap.set("n", "[w", "<Cmd>wincmd W<CR>")
vim.keymap.set("n", "<BS>", "<Cmd>wincmd p<CR>")
vim.keymap.set("n", "<Left>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<Down>", "<Cmd>wincmd j<CR>")
vim.keymap.set("n", "<Up>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<Right>", "<Cmd>wincmd l<CR>")
vim.keymap.set("n", "<A-c>", "<Cmd>wincmd c<CR>")
vim.keymap.set("n", "<A-o>", "<Cmd>wincmd o<CR>")
for i = 1, 9 do
  vim.keymap.set(
    "n",
    string.format("<A-%d>", i),
    string.format("<Cmd>%dwincmd w<CR>", i)
  )
end

-- Quickfix
vim.keymap.set("n", "<A-q>", "<Cmd>botright copen<CR>")
vim.keymap.set("n", "<Leader>qq", "<Cmd>cclose<CR>")

-- Help
vim.keymap.set("n", "<Leader>qh", "<Cmd>helpclose<CR>")

-- Select mode
-- Derived from https://github.com/Saghen/blink.cmp/issues/830#issuecomment-2566814094
vim.keymap.set(
  "s",
  "<BS>",
  "<C-g>c",
  { desc = "Delete selection and enter insert mode" }
)
