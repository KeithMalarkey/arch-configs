-- 格式化插件formatters
return {
	"stevearc/conform.nvim",
	lazy = true,
	event = {
		"BufReadPost",
		"BufNewFile",
		"InsertLeave",
		"TextChanged",
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			rust = { "rustfmt" },
			cpp = { "clang-format" },
			hpp = { "clang-format" },
			cu = { "clang-format" },
			cc = { "clang-format" },
			h = { "clang-format" },
			cxx = { "clang-format" },
			tpp = { "clang-format" },
			json = { "jq" },
			tex = { "tex-fmt" },
			bib = { "tex-fmt" },
			c = { "clang-format" },
			cmake = { "gersemi" },
			yaml = { "yamlfmt" },
			yml = { "yamlfmt" },
			-- shell 统一用 shfmt：支持 bash/sh/zsh 三种方言，
			-- 会按文件名自动识别方言（.zshrc → zsh）
			bash = { "shfmt" },
			sh = { "shfmt" },
			zsh = { "shfmt" },
			kdl = { "kdlfmt" },
			toml = { "tombi" },
			markdown = { "doctoc" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		-- 日志级别：默认 ERROR（只记错误），避免 conform.log 无限膨胀
		log_level = vim.log.levels.ERROR,
		formatters = {
			-- shfmt 默认用 tab 缩进，这里固定成 4 空格（和 stylua 风格一致）
			shfmt = {
				args = function(_, ctx)
					local args = { "-filename", "$FILENAME" }
					local has_editorconfig = vim.fs.find(".editorconfig", { path = ctx.dirname, upward = true })[1]
						~= nil
					if not has_editorconfig then
						vim.list_extend(args, { "-i", "4" })
					end
					return args
				end,
			},
		},
	},
}
