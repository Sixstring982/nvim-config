vim.api.nvim_create_user_command("ToggleEslint", function()
	require("null-ls").toggle("eslint")
end, {})
