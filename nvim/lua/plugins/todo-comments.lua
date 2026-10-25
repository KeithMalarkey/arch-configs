return {
	-- 评论插件，显示todo, warn等等，同时实现快速注释块插入
	{
		"folke/todo-comments.nvim",
		-- plenary 集中在 deps.lua（运行时 require 自动加载），这里不再声明
		opts = {
			-- 语义化配色 + 仅关键词/文字染色（注释符号 //、# 保持原色，不显突兀）
			highlight = {
				before = "", -- 不染注释符号
				keyword = "wide", -- 关键词 + 前后字符一起加底色，最醒目
				after = "fg", -- 冒号后的描述文字也染色
			},
			-- 用独立的高对比度 hex 色覆盖默认映射，
			-- 不依赖 Diagnostic* 系列，跨主题表现一致
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" }, -- FIX 系列：Bug 红
				warning = { "DiagnosticWarn", "WarningMsg", "#FB923C" }, -- WARN 系列：告警橙
				info = { "DiagnosticInfo", "#60A5FA" }, -- TODO：行动蓝
				hint = { "DiagnosticHint", "#34D399" }, -- NOTE：中性青绿
				default = { "Identifier", "#A78BFA" }, -- PERF：性能紫
				test = { "Identifier", "#F472B6" }, -- TEST：测试品红
			},
			keywords = {
				FIX = {
					icon = " ",
					color = "error", -- 红
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
				},
				TODO = { icon = " ", color = "info" }, -- 蓝
				HACK = { icon = " ", color = "warning" }, -- 橙
				WARN = {
					icon = " ",
					color = "warning", -- 橙
					alt = { "WARNING", "XXX" },
				},
				PERF = {
					icon = " ",
					color = "default", -- 紫
					alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
				},
				NOTE = {
					icon = " ",
					color = "hint", -- 青
					alt = { "INFO" },
				},
				TEST = {
					icon = "⏲ ",
					color = "test", -- 品红
					alt = { "TESTING", "PASSED", "FAILED" },
				},
			},
		},
	},
}
