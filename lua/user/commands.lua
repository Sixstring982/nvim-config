local M = { }

local last_command = ""

M.runInTmux = function(command) 
  last_command = command
  os.execute([[tmux send-keys -t 0 "]] .. command .. [[" Enter]])
end

M.reRunInTmux = function()
  M.runInTmux(last_command)
end

M.tmuxCtrlC = function(command) 
  os.execute([[tmux send-keys -t 0 C-c]])
end

return M
