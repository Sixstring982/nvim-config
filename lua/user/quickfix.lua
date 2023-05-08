local M = {}

M.populate_quickfix_with_command = function(cmd, extract_location)
  local output = vim.fn.systemlist(cmd)
  if output == "" then
    return
  end


  local qflist = {}
  for _, line in ipairs(output) do
    local filename, line, column, message = extract_location(line)
    if filename ~= nil then
      table.insert(qflist, {
        filename = filename,
        lnum = line,
        col = column,
        text = message,
        type = "E",
      })
    end
  end

  vim.fn.setqflist({}, "r", { title = "Quickfix", items = qflist })

  if #qflist > 0 then
    vim.cmd("copen")
  end
end

return M
