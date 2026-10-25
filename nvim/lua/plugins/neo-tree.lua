-- 目录树
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		-- plenary / nui / devicons 集中在 deps.lua，由 require 自动加载兜底
		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						visible = true, -- 显示所有文件，包括隐藏的
						hide_dotfiles = false, -- 不隐藏 . 开头的文件
						hide_gitignored = false, -- 不隐藏 .gitignore 中的文件
						hide_by_name = {
							-- 这里可以指定要隐藏的文件名
							"node_modules",
							".",
							"..",
						},
						hide_by_pattern = {
							-- 使用模式匹配隐藏文件
							-- "*.meta",
						},
						always_show = {
							-- 总是显示这些文件，即使匹配了隐藏规则
							".gitignore",
						},
						never_show = {
							-- 从不显示这些文件
						},
					},
					window = { width = 25 },
				},
			})
		end,
		lazy = true,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		-- plenary 集中在 deps.lua
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		config = function()
			require("window-picker").setup()
		end,
	},
}
