-- List tags before jumping if more than one match
vim.keymap.set(
  { "n", "v" },
  "<C-]>",
  "g<C-]>",
  { desc = "Tag: Jump to definition" }
)

-- Open tags in splits
vim.keymap.set(
  "n",
  "<A-]>s",
  "<Cmd>wincmd g<C-]><CR>",
  { desc = "Tag: Open definition in horizontal split" }
)
vim.keymap.set(
  "n",
  "<A-]>v",
  "<Cmd>vertical wincmd g<C-]><CR>",
  { desc = "Tag: Open definition in vertical split" }
)

-- Buffers
vim.keymap.set(
  "n",
  "<Leader><BS>",
  "<Cmd>bdelete<CR>",
  { desc = "Unload current buffer" }
)

-- Window navigation
vim.keymap.set(
  "n",
  "]w",
  "<Cmd>wincmd w<CR>",
  { desc = "Go to N next window (wrap around)" }
)
vim.keymap.set(
  "n",
  "[w",
  "<Cmd>wincmd W<CR>",
  { desc = "Go to N previous window (wrap around)" }
)
vim.keymap.set(
  "n",
  "<BS>",
  "<Cmd>wincmd p<CR>",
  { desc = "Go to last accessed window" }
)
vim.keymap.set(
  "n",
  "<Left>",
  "<Cmd>wincmd h<CR>",
  { desc = "Go to Nth left window (stop at first)" }
)
vim.keymap.set(
  "n",
  "<Down>",
  "<Cmd>wincmd j<CR>",
  { desc = "Go N windows down (stop at last)" }
)
vim.keymap.set(
  "n",
  "<Up>",
  "<Cmd>wincmd k<CR>",
  { desc = "Go N windows up (stop at first)" }
)
vim.keymap.set(
  "n",
  "<Right>",
  "<Cmd>wincmd l<CR>",
  { desc = "Go to Nth right window (stop at last)" }
)
vim.keymap.set(
  "n",
  "<A-c>",
  "<Cmd>wincmd c<CR>",
  { desc = "Close current window" }
)
vim.keymap.set(
  "n",
  "<A-o>",
  "<Cmd>wincmd o<CR>",
  { desc = "Close all but current window" }
)
for i = 1, 9 do
  vim.keymap.set(
    "n",
    string.format("<A-%d>", i),
    string.format("<Cmd>%dwincmd w<CR>", i),
    { desc = "Go to window " .. i }
  )
end

-- Quickfix
vim.keymap.set(
  "n",
  "<A-q>",
  "<Cmd>botright copen<CR>",
  { desc = "Open quickfix window" }
)
vim.keymap.set(
  "n",
  "<Leader>qq",
  "<Cmd>cclose<CR>",
  { desc = "Close quickfix window" }
)

-- Help
vim.keymap.set(
  "n",
  "<Leader>qh",
  "<Cmd>helpclose<CR>",
  { desc = "Close one help window" }
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

-- Search
-- Derived from https://github.com/neovim/neovim/discussions/24285#discussioncomment-6445365
vim.keymap.set("n", "z*", function()
  local cword = vim.fn.escape(vim.fn.expand("<cword>"), [[/\]])
  vim.fn.setreg("/", string.format([[\V\<%s\>]], cword))

  vim.fn.histadd("/", vim.fn.getreg("/"))
  vim.o.hlsearch = true
end, { desc = "Highlight all occurrences of word under cursor" })

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
