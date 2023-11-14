local M = {}

local default = function(val, default_val)
	if val == nil then
		return default_val
	end

	return val
end

local cmd_stdout = function(cmd, separator)
	local sep = default(separator, "")

	local handle = io.popen(cmd)
	if handle == nil then
		return nil
	end

	local output = handle:read("*a"):gsub("\n", sep)
	if output == "" then
		return nil
	end

	return output
end

M.path_relative_to_repo_root = function(path)
	local root = cmd_stdout("git rev-parse --show-toplevel 2>/dev/null")
	if root == nil then
		root = cmd_stdout("sl root 2>/dev/null")
	end
	if root == nil then
		error("Can't find repo root!")
	end

	return root .. path
end

M.relative_pending_files = function(path)
	local files = cmd_stdout("cd " .. path .. " && git diff --relative --name-only HEAD 2>/dev/null", " ")
	if files == nil then
		files = cmd_stdout("cd " .. path .. " && sl st --no-status 2>/dev/null", " ")
	end
	if files == nil then
		error("Can't query pending files!")
	end

	return files
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
