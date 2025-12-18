return {
  {
    LazyDep("which-key"),
    optional = true,

    opts = function(_, opts)
      if opts.spec == nil then opts.spec = {} end

      local key_descs = {
        c = "Comment",
        C = "Comment with surrounding whitespace",
      }
      for key, desc in pairs(key_descs) do
        for _, prefix in pairs({ "a", "i" }) do
          table.insert(opts.spec, {
            prefix .. key,
            mode = { "o", "x" },
            desc = desc,
          })
        end
      end
    end,
  },

  {
    "glts/vim-textobj-comment",
    dependencies = "kana/vim-textobj-user",

    event = "ModeChanged",
  },

  { import = "plugins.text-objects.various-textobjs" },
}
