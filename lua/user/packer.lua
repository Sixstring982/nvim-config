local packer_install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local is_bootstrapped = false

-- If packer hasn"t previously been installed, git clone and install it
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
	is_bootstrapped = true
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. packer_install_path)
	vim.cmd.packadd("packer.nvim")
end

-- Set up an autocmd to automatically run PackerCompile on updates to this file
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerSync",
	group = vim.api.nvim_create_augroup("recompile_packer", { clear = true }),
	pattern = vim.fn.stdpath("config") .. "/lua/user/packer.lua",
})

local packer = require("packer")

-- Packer configuration
local conf = {
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
}

packer.init(conf)

packer.startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	--
	-- Color schemes
	--

	use("catppuccin/nvim")
	use("rakr/vim-two-firewatch")
	use("morhetz/gruvbox")
	use("savq/melange-nvim")

	-- Install treesitter for better syntax highlighting
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})

	-- Additional text objects for treesitter
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	-- Fidget: LSP indicator
	use({
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = function()
			require("fidget").setup({})
		end,
	})

	-- Install LSP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			-- Plugin and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Install null-ls for diagnostics, code actions, and formatting
			"jose-elias-alvarez/null-ls.nvim",

			-- Install neodev for better nvim configuration and plugin authoring via lsp configurations
			"folke/neodev.nvim",
		},
	})

	-- LuaSnip: Snippet engine
	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
	})

	-- Install Autocomplete dependencies
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
	})

	-- Install telescope
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	-- Install fuzzy finder for telescope
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
		cond = vim.fn.executable("make") == 1,
	})

	-- Install nvim-tree for a vscode-like file tree/explorer
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			-- vscode icones
			"nvim-tree/nvim-web-devicons",
			-- Integrate lsp actions with file operations
			"antosha417/nvim-lsp-file-operations",
		},
		tag = "nightly",
	})

	-- Install indent_blankline to style indentation
	use("lukas-reineke/indent-blankline.nvim")

	-- Install vim-surround for managing parenthese, brackets, quotes, etc
	use("tpope/vim-surround")

	-- Install context-commentstring to enable jsx commenting is ts/js/tsx/jsx files
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Install vim-illuminate to hightlight other uses of the word under your cursor
	use("RRethy/vim-illuminate")

	-- Syntax highlighting for ".astro" (SSG) files
	use("wuelnerdotexe/vim-astro")

	-- Git Fugitive: kind of like magit
	use("tpope/vim-fugitive")

	-- Undotree: for visualizing the undo tree
	use("mbbill/undotree")

	-- Wilder: Better wildmenu, for completions and whatnot
	use("gelguy/wilder.nvim")

	-- Dressing: Styles certain completion menus, like code_action and rename
	use("stevearc/dressing.nvim")

	-- Harpoon: Mark buffers for StarCraft switching power
	use({
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Ag: Silver searcher bindings
	use("Numkil/ag.nvim")

	-- .j2 syntax highlighting
	use("glench/vim-jinja2-syntax")

	-- Dadbod: Database helper
	use("tpope/vim-dadbod")

	-- UI for Dadbod
	use("kristijanhusak/vim-dadbod-ui")

	-- Abolish: Case-sensitivity helper
	use("tpope/vim-abolish")

	-- Commentary: Comment helper
	use("tpope/vim-commentary")

	-- rest-nvim: REST client, like Insomnia
	use({
		"rest-nvim/rest.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		commit = "8b62563",
		config = function()
			require("rest-nvim").setup({
				-- Open request results in a horizontal split
				result_split_horizontal = true,
				-- Keep the http file buffer above|left when split horizontal|vertical
				result_split_in_place = false,
				-- Skip SSL verification, useful for unknown certificates
				skip_ssl_verification = false,
				-- Encode URL before making request
				encode_url = true,
				-- Highlight request on run
				highlight = {
					enabled = true,
					timeout = 150,
				},
				result = {
					-- toggle showing URL, HTTP info, headers at top the of result window
					show_url = true,
					-- show the generated curl command in case you want to launch
					-- the same request via the terminal (can be verbose)
					show_curl_command = false,
					show_http_info = true,
					show_headers = true,
					-- executables or functions for formatting response body [optional]
					-- set them to false if you want to disable them
					formatters = {
						json = "jq",
						html = function(body)
							return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
						end,
					},
				},
				-- Jump to request line on run
				jump_to_request = false,
				env_file = ".env",
				custom_dynamic_variables = {},
				yank_dry_run = true,
			})
		end,
	})

	if is_bootstrapped then
		require("packer").sync()
	end
end)
