;; extends

; Taken from https://github.com/ColinKennedy/nvim-treesitter-textobjects/commit/92e256d32518f895f392a21dd43924f2219cde4d
(expression_statement
 (string (string_content) @documentation.inner)) @documentation.outer
