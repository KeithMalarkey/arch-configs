return {
	-- markdown配合浏览器实现实时预览
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" }, -- 只在 markdown 文件加载
		config = function()
			vim.g.mkdp_auto_start = 0 -- 不自动启动
			vim.g.mkdp_auto_close = 1 -- 切换 buffer 时自动关闭
			vim.g.mkdp_refresh_slow = 0 -- 快速刷新
			vim.g.mkdp_command_for_global = 0 -- 仅 markdown 文件生效
			vim.g.mkdp_open_to_the_world = 0 -- 仅本地访问
			vim.g.mkdp_open_ip = "" -- 本地服务器 IP
			vim.g.mkdp_browser = "" -- 使用默认浏览器
			vim.g.mkdp_echo_preview_url = 1 -- 预览 URL 回显
			vim.g.mkdp_page_title = "${name}" -- 页面标题
			vim.g.mkdp_filetypes = { "markdown" }

			-- 主题适配
			vim.g.mkdp_theme = "dark" -- dark/light

			-- 快捷键（用 mps/mpt 避免和 mesone 的 <leader>ms / <leader>mt 冲突）
			vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview", buffer = true })
			vim.keymap.set("n", "<leader>mps", "<cmd>MarkdownPreviewStop<CR>", { desc = "Stop preview", buffer = true })
			vim.keymap.set(
				"n",
				"<leader>mpt",
				"<cmd>MarkdownPreviewToggle<CR>",
				{ desc = "Toggle preview", buffer = true }
			)
		end,
	},
}
