return {
	-- cmdline的浮动显示，非必需，但是推荐
	{
		"folke/noice.nvim",
		-- nui 集中在 deps.lua（noice 有 16 处 require，自动加载兜底）
		config = function()
			require("noice").setup({
				-- 命令行配置
				cmdline = {
					enabled = true, -- 启用 Noice 命令行
					view = "cmdline_popup", -- 浮窗形式
					format = {
						cmdline = { pattern = "^:", icon = "", lang = "vim" },
						search_down = { pattern = "^/", icon = "", lang = "regex" },
						search_up = { pattern = "^%?", icon = "", lang = "regex" },
						lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
						fish = {
							pattern = "^:!%s*fish%s*$",
							icon = "󰈺", -- fish 图标
							lang = "fish",
						},
					},
				},

				-- LSP 配置
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
					progress = { enabled = false, view = "mini" },
					hover = { enabled = false },
					signature = { enabled = false },
					message = { enabled = false, view = "notify" },
				},

				-- 接管 vim.notify：通知会显示成右下角浮窗，并且可以用
				-- :Noice history / :NoiceHistory 查看历史（之前是 false，等于没记录）
				notify = {
					enabled = true,
					view = "notify",
				},

				-- 预设
				presets = {
					bottom_search = false,
					command_palette = false,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	},
}
