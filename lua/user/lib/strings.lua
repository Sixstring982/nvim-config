local M = {}

M.ends_with = function(str, ending)
  return ending == "" or str:sub(-#ending) == ending
end

M.trim = function(str)
   return (str:gsub("^%s*(.-)%s*$", "%1"))
end

return M
