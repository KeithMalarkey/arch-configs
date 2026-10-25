-- image.nvim：在 nvim 内用 kitty 图形协议渲染图片
-- 依赖：ImageMagick + Ghostscript（渲染 PDF 时需要）、kitty >= 28（图形协议）
-- PDF 交给 pdfreader.nvim 处理（见 pdf.lua），这里不再劫持 *.pdf，
-- 否则两个插件会同时渲染同一个 PDF，且 pdfreader 的 n/p/z/q/e 按键会被覆盖。
return {
	"3rd/image.nvim",
	build = false, -- 使用 magick_cli，不编译 rock
	opts = {
		backend = "kitty",
		processor = "magick_cli",
		max_width_window_percentage = 100,
		max_height_window_percentage = 60,
		hijack_file_patterns = {
			"*.png",
			"*.jpg",
			"*.jpeg",
			"*.gif",
			"*.webp",
			"*.avif",
		},
	},
	keys = {
		{
			"<leader>ic",
			function()
				local ok, image = pcall(require, "image")
				if not ok then
					return
				end
				for _, img in ipairs(image.get_images({ buffer = vim.api.nvim_get_current_buf() })) do
					img:clear()
				end
			end,
			desc = "image.nvim: 清除当前缓冲区的渲染",
		},
		{ "<leader>ip", "<cmd>ImageReport<CR>", desc = "image.nvim: 渲染状态/错误报告" },
	},
}
