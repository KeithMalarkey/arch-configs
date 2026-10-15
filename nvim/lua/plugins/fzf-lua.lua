return {
	"ibhagwan/fzf-lua",
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	event = "UiEnter",

	-- 默认参数：所有 picker 共享
	-- cwd 通过下面 keys 中的回调按"项目根"动态计算
	opts = {
		-- 全局：尊重 .gitignore、默认隐藏文件 off、限制最大列宽
		files = {
			-- 额外的忽略规则（与 .gitignore 叠加，--type f 时忽略这些目录）
			find_opts = [[-type f \! -path '*/.git/*' \! -path '*/node_modules/*' \! -path '*/build/*' \! -path '*/dist/*' \! -path '*/.cache/*']],
			rg_opts   = [[--color=never --files -g "!.git" -g "!node_modules" -g "!build" -g "!dist" -g "!.cache"]],
			fd_opts   = [[--color=never --type f --type l --exclude .git --exclude node_modules --exclude build --exclude dist --exclude .cache]],
			hidden    = false,
			no_ignore = false,
		},
		grep = {
			-- rg/grep 默认参数（live_grep/grep 都共用）
			rg_opts   = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
			grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
			hidden    = false,
			no_ignore = false,
		},
		-- 美化提示符，便于看清当前 cwd
		winopts = {
			title_pos = "center",
			title     = " fzf-lua ",
		},
	},

	keys = function()
		-- 项目根解析。优先级：
		-- 1) 当前 buffer 已 attach 的 LSP client 的 root_dir（最准，覆盖多工作区）
		-- 2) git 仓库根（从 buffer 文件所在目录向上找）
		-- 3) fallback：buffer 文件所在目录
		--    注意：不用 vim.fn.getcwd()，因为 :e 打开其它目录的文件时 cwd 不会变，
		--    那时按 cwd 找根会搜错范围。
		local function project_root()
			-- 1) LSP root
			local bufnr = vim.api.nvim_get_current_buf()
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
				if client.config and client.config.root_dir and client.config.root_dir ~= "" then
					return client.config.root_dir
				end
			end
			-- 2) git root（从 buffer 所在目录开始搜）
			local buf_path = vim.api.nvim_buf_get_name(bufnr)
			local start_dir
			if buf_path ~= "" then
				start_dir = vim.fn.fnamemodify(buf_path, ":h")
			end
			if not start_dir or start_dir == "" then
				start_dir = vim.fn.getcwd()
			end
			local ok, git_root = pcall(function()
				return require("fzf-lua").path.git_root({ cwd = start_dir }, true)
			end)
			if ok and git_root and git_root ~= "" then
				return git_root
			end
			-- 3) fallback: buffer 目录 / cwd
			if start_dir and start_dir ~= "" then
				return start_dir
			end
			return vim.fn.getcwd()
		end

		local function with_root(picker)
			return function()
				require("fzf-lua")[picker]({ cwd = project_root() })
			end
		end

		return {
			-- 文件搜索：限定到项目根
			{ "<leader>ff", with_root("files"), desc = "find files (project root)" },
			-- live_grep：交互式，限定到项目根
			{ "<leader>fw", with_root("live_grep"), desc = "find words (live grep, project root)" },
			-- 手动输入 grep 模式（输入完整 regex）
			{ "<leader>fg", with_root("grep"), desc = "grep with regex (project root)" },
			-- 快速 grep 当前 buffer
			{ "<leader>fB", "<cmd>FzfLua grep_curbuf<cr>", desc = "grep current buffer" },
			-- 重新执行上一次搜索
			{
				"<leader>fr",
				function()
					require("fzf-lua").resume({ cwd = project_root() })
				end,
				desc = "resume last fzf (project root)",
			},
			-- nvim 配置目录（保留原行为，不变 cwd）
			{
				"<leader>fR",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "find nvim config root",
			},
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "find buffers" },
		}
	end,
	---@diagnostic enable: missing-fields
}