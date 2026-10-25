return {
	"stevearc/aerial.nvim",
	-- treesitter / lspconfig 都有自己的顶层 spec，devicons 集中在 deps.lua，
	-- 由 require 自动加载兜底，这里不再声明 dependencies
	event = { "VeryLazy", "BufReadPost" },
	config = function()
		require("aerial").setup({
			-- 后端配置（两个都启用）
			backends = { "lsp", "treesitter", "markdown" },

			-- 后端优先级
			backend_check = function(bufnr)
				-- 检查是否有可用的后端
				local ts_ok, _ = pcall(require, "nvim-treesitter.parsers")
				if ts_ok then
					local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
					local lang = require("nvim-treesitter.parsers").ft_to_lang(ft)
					if lang ~= nil and lang ~= "" then
						return true
					end
				end
				-- 回退到 LSP
				local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
				return #clients > 0
			end,

			-- 要显示的类型（推荐设置具体类型）
			-- filter_kind = {
			-- 	"Class",
			-- 	"Constructor",
			-- 	"Enum",
			-- 	"Function",
			-- 	"Interface",
			-- 	"Method",
			-- 	"Module",
			-- 	"Namespace",
			-- 	"Package",
			-- 	"Property",
			-- 	"Struct",
			-- 	"Trait",
			-- 	"Variable",
			-- 	"Constant",
			-- 	"Field",
			-- 	"Object",
			-- 	"TypeParameter",
			-- 	"Unit",
			-- 	"Value",
			-- 	"Event",
			-- 	"Operator",
			-- 	"Keyword",
			-- },

			filter_kind = false,
			-- 布局配置
			layout = {
				min_width = 30,
				max_width = 50,
				default_direction = "prefer_right",
				placement = "window",
				resize_to_content = true,
			},

			-- 其他配置
			show_guides = true,
			guide_chars = "│ ─├─└",
			autojump = false, -- 关闭自动跳转，手动控制更好
			close_on_select = true,
			highlight_on_hover = true,
			highlight_on_jump = true,

			-- 根据文件类型调整
			filetype_map = {
				["json"] = "json",
				["yaml"] = "yaml",
				["toml"] = "toml",
				["markdown"] = "markdown",
				["python"] = "python",
				["javascript"] = "javascript",
				["typescript"] = "typescript",
				["lua"] = "lua",
				["go"] = "go",
				["rust"] = "rust",
				["cpp"] = "cpp",
				["java"] = "java",
			},
		})

		-- 快捷键
		vim.keymap.set("n", "<leader>ol", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })
		vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { desc = "Previous symbol" })
		vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { desc = "Next symbol" })
	end,
	keys = {
		{ "<leader>ol", desc = "Toggle outline" },
		{ "[[", desc = "Previous symbol" },
		{ "]]", desc = "Next symbol" },
	},
}
