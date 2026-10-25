return {
	-- snacks中包含很多小组件，包括dashboard,notify...
	{
		"folke/snacks.nvim",
		config = function(_, opts)
			require("snacks").setup(opts)
			-- 让 Snacks 接管 UI 输入框（重命名文件等场景），比原生 vim.ui.input 好看
			-- 注意：picker 关着（用的是 fzf-lua），所以不接管 vim.ui.select
			vim.ui.input = require("snacks").input
		end,
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = table.concat({
						[[                               __                ]],
						[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
						[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
						[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
						[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
						[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
						[[                                                  ]],
					}, "\n"),
				},
			},
			bigfile = {
				enabled = false,
			},
			animate = {
				enabled = true,
			},
			bufdelete = {
				enabled = true,
			},
			dim = {
				enabled = true,
			},
			explorer = {
				enabled = false,
			},
			indent = {
				enabled = true,
			},
			input = {
				enabled = true,
			},
			picker = {
				enabled = false,
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			notify = {
				enabled = true,
			},
			quickfile = {
				enabled = false,
			},
			scope = {
				enabled = false,
			},
			scroll = {
				enabled = true,
			},
			statuscolumn = {
				enabled = true,
				opts = {
					left = { "mark", "sign" }, -- priority of signs on the left (high to low)
					right = { "fold", "git" }, -- priority of signs on the right (high to low)
					folds = {
						open = true, -- show open fold icons
						git_hl = true, -- use Git Signs hl for fold icons
					},
					git = {
						-- patterns to match Git signs
						patterns = { "GitSign", "MiniDiffSign" },
					},
					refresh = 50, -- refresh at most every 50ms
				},
			},
			words = {
				enabled = true,
			},
		},
		priority = 1000,
	},
}
