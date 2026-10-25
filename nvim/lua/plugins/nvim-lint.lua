-- 句法检查插件
return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
		config = function()
			-- 自定义 linter：shuck（bash/zsh/posix/mksh 方言都支持）
			-- shuck 的 LSP 走的是 pull diagnostics，Neovim 目前不会自动拉取，
			-- 所以诊断改由这个 linter 提供（走 stdin，能拿到缓冲区最新内容）
			require("lint").linters.shuck = {
				cmd = "shuck",
				stdin = true,
				args = {
					"check",
					"--output-format",
					"json-lines",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
					"-",
				},
				stream = "stdout",
				ignore_exitcode = true,
				parser = function(output)
					local diags = {}
					for _, line in ipairs(vim.split(output, "\n", { trimempty = true })) do
						local ok, d = pcall(vim.json.decode, line)
						if ok and d and d.location then
							local severity = vim.diagnostic.severity.INFO
							if d.severity == "error" then
								severity = vim.diagnostic.severity.ERROR
							elseif d.severity == "warning" then
								severity = vim.diagnostic.severity.WARN
							end
							table.insert(diags, {
								-- vim.diagnostic.set 用的是 0 基行/列，shuck 输出的是 1 基
								lnum = math.max(0, (d.location.row or 1) - 1),
								col = math.max(0, (d.location.column or 1) - 1),
								message = string.format("%s: %s", d.code or "shuck", d.message or ""),
								severity = severity,
								source = "shuck",
							})
						end
					end
					return diags
				end,
			}

			-- 自定义 linter：vale_tex
			-- vale 没有 LaTeX 解析器（官方 issue #54 = Won't Fix），直接查 .tex 会把
			-- \setbeamercolor{fg = white}、$a_n$ 这类内容当成拼写错误。
			-- 所以用 scripts/vale-tex.sh：先用 texplain 剥掉 LaTeX 标记（行号保持 1:1），
			-- 再交给 vale 检查，误报能降一个数量级。
			require("lint").linters.vale_tex = {
				cmd = vim.fn.expand("~/.config/nvim/scripts/vale-tex.sh"),
				stdin = true,
				args = {},
				stream = "stdout",
				ignore_exitcode = true,
				parser = require("lint.parser").from_errorformat("%l:%c:%m", {
					source = "vale",
					severity = vim.diagnostic.severity.WARN,
				}),
			}

			-- markdown 用 vale 原生的（不需要剥标记）
			require("lint").linters.vale = vim.tbl_extend("force", require("lint").linters.vale, {
				ignore_exitcode = true, -- 没有 .vale.ini 时不要在编辑器里弹 exit code 2
			})

			require("lint").linters_by_ft = {
				-- 按文件类型配置检查器
				python = { "bandit" },
				lua = { "luacheck" },
				java = { "checkstyle" },
				cmake = { "cmakelang" },
				cpp = { "cpplint" },
				rust = { "bacon" },
				json = { "jsonlint" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				zsh = { "shellcheck" },
				markdown = { "vale" },
				tex = { "vale" },
				vimScript = { "vint" },
				yaml = { "yamllint" },
			}

			-- 自动命令：保存时检查
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
