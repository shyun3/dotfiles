return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = {
      spec = {
        { "a=", mode = { "o", "x" }, desc = "Conflict" },
        { "i=", mode = { "o", "x" }, desc = "Conflict" },
      },
    },
  },

  {
    "rhysd/vim-textobj-conflict",
    dependencies = LazyDep("vim-textobj-user"),

    event = "ModeChanged",

    init = function()
      -- Does not support jj "snapshot" style conflict markers
      vim.g["g:textobj#conflict#begin"] = [[\v^[<]{7,} @=]]
      vim.g["g:textobj#conflict#end"] = [[\v^[>]{7,} @=]]
      vim.g["g:textobj#conflict#separator"] = [[\v^([=]{7,}$|[+]{7,} @=)]]
    end,
  },
}
