local M = {}

local last_verbatim_command = ""
M.run = function (command)
  last_verbatim_command = command
  os.execute("tmux send-keys -t 0 '" .. command .. "' Enter")
end

M.re_run = function ()
  M.run(last_verbatim_command)
end

M.ctrl_c = function ()
  os.execute("tmux send-keys -t 0 C-c")
end

return M

