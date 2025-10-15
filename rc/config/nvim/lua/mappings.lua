-- List tags before jumping if more than one match
vim.keymap.set(
  { "n", "v" },
  "<C-]>",
  "g<C-]>",
  { desc = "Tag: Jump to definition" }
)

-- Buffers
vim.keymap.set(
  "n",
  "<Leader><BS>",
  "<Cmd>bdelete<CR>",
  { desc = "Unload buffer" }
)

-- Window navigation
vim.keymap.set("n", "]w", "<Cmd>wincmd w<CR>", { desc = "Next window" })
vim.keymap.set("n", "[w", "<Cmd>wincmd W<CR>", { desc = "Previous window" })
vim.keymap.set(
  "n",
  "<BS>",
  "<Cmd>wincmd p<CR>",
  { desc = "Last accessed window" }
)
vim.keymap.set("n", "<Left>", "<Cmd>wincmd h<CR>", { desc = "Left window" })
vim.keymap.set("n", "<Down>", "<Cmd>wincmd j<CR>", { desc = "Below window" })
vim.keymap.set("n", "<Up>", "<Cmd>wincmd k<CR>", { desc = "Above window" })
vim.keymap.set("n", "<Right>", "<Cmd>wincmd l<CR>", { desc = "Right window" })
vim.keymap.set("n", "<A-c>", "<Cmd>wincmd c<CR>", { desc = "Close window" })
vim.keymap.set(
  "n",
  "<A-o>",
  "<Cmd>wincmd o<CR>",
  { desc = "Close other windows" }
)
for i = 1, 9 do
  vim.keymap.set(
    "n",
    string.format("<A-%d>", i),
    string.format("<Cmd>%dwincmd w<CR>", i),
    { desc = "Window " .. i }
  )
end

-- Quickfix
vim.keymap.set(
  "n",
  "<A-q>",
  "<Cmd>botright copen<CR>",
  { desc = "Open quickfix window" }
)

-- Highlights
vim.keymap.set("n", "zS", vim.show_pos, { desc = "Inspect" })

-- Select mode
-- Derived from https://github.com/Saghen/blink.cmp/issues/830#issuecomment-2566814094
vim.keymap.set(
  "s",
  "<BS>",
  "<C-g>c",
  { desc = "Delete selection and enter insert mode" }
)

-- Undo
vim.keymap.set("n", "<A-u>", function()
  local files = 0
  for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(buf_id)
      and vim.api.nvim_get_option_value("modified", { buf = buf_id })
    then
      vim.api.nvim_buf_call(buf_id, vim.cmd.undo)
      files = files + 1
    end
  end

  local msg = string.format("Undid changes in %d file(s)", files)
  vim.notify(msg)
end, { desc = "Undo changes in all modified buffers" })
