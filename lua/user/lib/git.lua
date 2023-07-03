local M = {}

M.path_relative_to_repo_root = function (path)
  local handle = io.popen('git rev-parse --show-toplevel')
  local output = handle:read('*a'):gsub("\n", "")

  return output .. path
end

-- Returns the absolute path of the repository root.
M.code_path = function()
	return M.path_relative_to_repo_root("")
end

-- Returns the absolute path of the frontend root.
M.frontend_path = function()
	return M.path_relative_to_repo_root("/frontend")
end

return M
