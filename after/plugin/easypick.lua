local easypick = require("easypick")

easypick.setup({
	pickers = {
		{
			name = "yarn_tasks",
			-- the command to execute, output has to be a list of plain text entries
			command = [[yarn run --json | tail -n 1 | jq -r '.data.hints | keys[]']],
			previewer = easypick.previewers.default(),
      action = easypick.actions.nvim_commandf("lua require('user.lib.tmux').run('yarn %s')")
		},
	}
})

