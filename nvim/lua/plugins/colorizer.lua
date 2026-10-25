return {
	-- RGB彩色实时预览
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" }, -- 延迟加载
		config = function()
			require("colorizer").setup({
				"*", -- 所有文件类型
			}, {
				RGB = true,
				RRGGBB = true,
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
			})

			-- 自动为所有文件启用
			vim.cmd("ColorizerAttachToBuffer")
		end,
	},
}
