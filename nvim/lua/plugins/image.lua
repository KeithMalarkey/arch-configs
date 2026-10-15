-- image.nvim：在 nvim 内用 kitty 图形协议渲染图片 / PDF（告别二进制"串码"）
-- 依赖：ImageMagick + Ghostscript（渲染 PDF）、kitty >= 28（图形协议）
-- 打开 .pdf 时 image.nvim 内置 BufWinEnter 劫持会自动渲染，无需额外 autocmd
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
			"*.pdf",
		},
	},
	-- 保存 .tex 后：latexmk 重编译，若对应的 .pdf 正在窗口里显示则自动刷新渲染
	config = function(_, opts)
		require("image").setup(opts)

		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.tex",
			callback = function()
				local ok, image = pcall(require, "image")
				if not ok or not image.is_enabled() then
					return
				end
				local base = vim.fn.expand("%:t:r")
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local name = vim.api.nvim_buf_get_name(buf)
					if name:match("^" .. vim.pesc(base) .. "%.pdf$") then
						local win = vim.fn.bufwinid(buf)
						if win ~= -1 then
							pcall(image.hijack_buffer, name, win, buf)
						end
					end
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>ir",
			function()
				local name = vim.api.nvim_buf_get_name(0)
				if name:match("%.pdf$") then
					pcall(require("image").hijack_buffer, name, 0, 0)
				end
			end,
			desc = "image.nvim: 重新渲染当前 PDF",
		},
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
