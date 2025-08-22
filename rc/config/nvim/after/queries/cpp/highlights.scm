; extends

"static_assert" @keyword

((identifier) @keyword
  (#any-of? @keyword "static_cast" "const_cast" "reinterpret_cast" "dynamic_cast"))
