-- lazy.nvim plugin config
return {
	"lervag/vimtex",
	lazy = false, -- 不要 lazy load
	init = function()
		vim.g.vimtex_view_method = "zathura_simple" -- PDF 查看器（无 xdotool，用 simple 变体，仍支持正反向搜索）
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_view_automatic = 1 -- 编译后自动打开/刷新 zathura
		vim.g.vimtex_compiler_latexmk = {
			executable = "latexmk",
			options = {
				"-xelatex", -- 这里关键，fontspec 必须用 XeLaTeX
				"-shell-escape",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
			},
		}
	end,
	config = function()
		-- 常用实时预览键位：<leader>ll 编译、<leader>lv 打开/刷新 PDF
		vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>", { desc = "LaTeX: 编译并刷新 PDF" })
		vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { desc = "LaTeX: 打开/定位 PDF (zathura)" })
		vim.keymap.set("n", "<leader>ls", "<cmd>VimtexStop<CR>", { desc = "LaTeX: 停止编译" })
		vim.keymap.set("n", "<leader>le", "<cmd>VimtexErrors<CR>", { desc = "LaTeX: 显示编译错误" })
		vim.keymap.set("n", "<leader>lt", "<cmd>VimtexTocToggle<CR>", { desc = "LaTeX: 目录面板" })

		-- TexLab 提供的命令（\ref 跳转、补全等由 LSP 自动提供）
		-- LspTexlabForward: 从 .tex 光标位置正向搜索到 zathura
		vim.keymap.set(
			"n",
			"<leader>lf",
			"<cmd>LspTexlabForward<CR>",
			{ desc = "LaTeX: 正向搜索到 PDF (zathura)" }
		)
		-- LspTexlabBuild: 用 texlab 自己的方式编译
		vim.keymap.set("n", "<leader>lb", "<cmd>LspTexlabBuild<CR>", { desc = "LaTeX: TexLab 编译" })
		-- LspTexlabFindEnvironments: 列出当前位置可用的环境
		vim.keymap.set("n", "<leader>le2", "<cmd>LspTexlabFindEnvironments<CR>", { desc = "LaTeX: 查找可用环境" })
	end,
}
