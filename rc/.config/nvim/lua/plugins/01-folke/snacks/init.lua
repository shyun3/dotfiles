return {
  LazyDep("snacks"),

  -- See `:checkhealth snacks`
  lazy = false, -- Should not be lazy loaded
  priority = 1000, -- Should have priority of 1000 or higher
}
