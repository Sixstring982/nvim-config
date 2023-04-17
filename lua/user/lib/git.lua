local M = {}

M.path_relative_to_repo_root = function (path)
  local handle = io.popen('git rev-parse --show-toplevel')
  local output = handle:read('*a'):gsub("\n", "")

  return output .. path
end

return M
