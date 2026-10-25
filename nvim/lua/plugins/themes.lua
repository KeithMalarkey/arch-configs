-- 主题设置
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		-- 按需加载：启动时不加载（原来 priority=1000 会启动加载但从未被 colorscheme 应用）
		-- 想切换主题时：先 `:Lazy load catppuccin`，再 `:colorscheme catppuccin-mocha`
		-- （lazy.nvim 没有 colorscheme 处理器，colorscheme 命令本身不会触发加载）
		lazy = true,
		opts = { flavour = "mocha", transparent_background = true },
	},
	{
		"ellisonleao/gruvbox.nvim",
		-- priority=1000 已让它启动时加载，原来的 event = "VeryLazy" 在此无效，已删除
		priority = 1000,
		config = true,
		opts = { transparent_mode = true },
	},
}
