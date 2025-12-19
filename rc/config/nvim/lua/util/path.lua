--- If returning false/nil, normalizer is not applied
---@alias Normalizer fun(path: string): string | false | nil

local M = {}

local S = {
  ---@type Normalizer[]
  normalizers = {},
}

---@param norm Normalizer
function M.register_normalizer(norm) S.normalizers[#S.normalizers + 1] = norm end

---@param path string
---@param norms? Normalizer[] If nil, uses registered normalizers
function M.normalize(path, norms)
  norms = norms or S.normalizers

  for _, norm in pairs(S.normalizers) do
    local norm_path = norm(path)
    if norm_path then return norm_path end
  end

  return path
end

return M
