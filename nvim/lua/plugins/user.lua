return {
	-- 语法高亮及解析，很重要，作为很多插件的依赖，建议放在顶部优先load,设置优先级priority
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		-- dependencies = {
		-- 	"nvim-treesitter/nvim-treesitter-textobjects",
		-- 	"nvim-treesitter/nvim-treesitter-refactor",
		-- 	"nvim-treesitter/nvim-treesitter-context",
		-- },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter").setup({
				auto_install = true, -- 缺少解析器时自动安装
				modules = {}, -- 默认为空即可
				sync_install = false, -- 同步安装关闭
				ignore_install = {}, -- 忽略的语言列表
			})
		end,
		priority = 1000,
	},
	-- 快速推出normal模式的插件
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
	-- snacks中包含很多小组件，包括dashboard,notify...
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = table.concat({
						[[                               __                ]],
						[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
						[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
						[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
						[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
						[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
						[[                                                  ]],
					}, "\n"),
				},
			},
			bigfile = {
				enabled = false,
			},
			animate = {
				enabled = true,
			},
			bufdelete = {
				enabled = true,
			},
			dim = {
				enabled = true,
			},
			explorer = {
				enabled = false,
			},
			indent = {
				enabled = true,
			},
			input = {
				enabled = true,
			},
			picker = {
				enabled = false,
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			notify = {
				enabled = true,
			},
			quickfile = {
				enabled = false,
			},
			scope = {
				enabled = false,
			},
			scroll = {
				enabled = true,
			},
			statuscolumn = {
				enabled = true,
				opts = {
					left = { "mark", "sign" }, -- priority of signs on the left (high to low)
					right = { "fold", "git" }, -- priority of signs on the right (high to low)
					folds = {
						open = true, -- show open fold icons
						git_hl = true, -- use Git Signs hl for fold icons
					},
					git = {
						-- patterns to match Git signs
						patterns = { "GitSign", "MiniDiffSign" },
					},
					refresh = 50, -- refresh at most every 50ms
				},
			},
			words = {
				enabled = true,
			},
		},
		priority = 1000,
	},
	-- which-key映射表，并检查kepmapping问题（重复错误等）
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- 评论插件，显示todo, warn等等，同时实现快速注释块插入
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
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
	-- mini icon
	{
		"nvim-mini/mini.nvim",
		version = "*",
	},
	-- telescope 在 rgrep 时经常崩溃，使用 fzf-lua 代替
	-- telescope 实现文件/目录（按文件名/关键词）的模糊查询，文件预览，vim commands的查询等等
	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	tag = "v0.2.1",
	-- 	event = "UiEnter",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		{
	-- 			"nvim-telescope/telescope-fzf-native.nvim",
	-- 			build = "make",
	-- 		},
	-- 	},
	-- 	-- 只有在按键触发式加载，最懒加载
	-- 	keys = {
	-- 		{
	-- 			"<leader>ff",
	-- 			"<cmd>Telescope find_files<cr>",
	-- 			desc = "Find Files",
	-- 		},
	-- 		{
	-- 			"<leader>fw",
	-- 			"<cmd>Telescope live_grep<cr>",
	-- 			desc = "Find Words",
	-- 		},
	-- 		{
	-- 			"<leader>fb",
	-- 			"<cmd>Telescope buffers<cr>",
	-- 			desc = "Find Buffers",
	-- 		},
	-- 		{
	-- 			"<leader>fh",
	-- 			"<cmd>Telescope help_tags<cr>",
	-- 			desc = "Help Tags",
	-- 		},
	-- 	},
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>fr", function()
	-- 			require("telescope.builtin").find_files({
	-- 				cwd = vim.fn.stdpath("config"),
	-- 			})
	-- 		end)
	-- 		require("telescope").load_extension("fidget")
	-- 		require("telescope").setup({
	-- 			defaults = {
	-- 				file_ignore_patterns = { -- 默认忽略列表
	-- 					"node_modules",
	-- 					".git", -- 可以根据需要调整
	-- 				},
	-- 				-- 启用隐藏文件
	-- 				hidden = true,
	-- 			},
	-- 			pickers = {
	-- 				find_files = {
	-- 					-- 查找文件时包含隐藏文件
	-- 					hidden = true,
	-- 					-- 或者更精确的控制
	-- 					find_command = {
	-- 						"rg",
	-- 						"--files",
	-- 						"--hidden",
	-- 						"--glob",
	-- 						"!**/.git/*",
	-- 						"--glob",
	-- 						"!**/node_modules/*",
	-- 					},
	-- 				},
	-- 				live_grep = {
	-- 					-- 实时搜索时包含隐藏文件
	-- 					additional_args = function()
	-- 						return { "--hidden" }
	-- 					end,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- gitsigns显示git变动
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = {
						text = "┃",
					},
					change = {
						text = "┃",
					},
					delete = {
						text = "_",
					},
					topdelete = {
						text = "‾",
					},
					changedelete = {
						text = "~",
					},
					untracked = {
						text = "┆",
					},
				},
				signs_staged = {
					add = {
						text = "┃",
					},
					change = {
						text = "┃",
					},
					delete = {
						text = "_",
					},
					topdelete = {
						text = "‾",
					},
					changedelete = {
						text = "~",
					},
					untracked = {
						text = "┆",
					},
				},
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
	-- 智能窗口分割插件，没必要用插件
	-- {
	-- 	"mrjones2014/smart-splits.nvim",
	-- 	config = function()
	-- 		-- split windows
	-- 		vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", {
	-- 			desc = "vertical split",
	-- 		})
	-- 		vim.keymap.set("n", "<leader>\\", "<cmd>split<CR>", {
	-- 			desc = "horizontal split",
	-- 		})
	-- 		-- moving between splits
	-- 		vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, {
	-- 			desc = "left split/window",
	-- 		})
	-- 		vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, {
	-- 			desc = "down split/window",
	-- 		})
	-- 		vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, {
	-- 			desc = "up split/window",
	-- 		})
	-- 		vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, {
	-- 			desc = "right split/window",
	-- 		})
	-- 		vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous, {
	-- 			desc = "previous split/window",
	-- 		})
	-- 		-- resize splits
	-- 		vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left)
	-- 		vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down)
	-- 		vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up)
	-- 		vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right)
	-- 	end,
	-- },
	-- 缓存区顶部指示栏
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = {
			"BufAdd",
			"BufEnter",
			"TabEnter",
			"TabNew",
		},
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					numbers = "none",
					themable = true,
					close_command = "bdelete! %d", -- 关闭命令
					right_mouse_command = "bdelete! %d", -- 右键命令
					left_mouse_command = "buffer %d", -- 左键命令
					middle_mouse_command = nil, -- 中键命令
					buffer_close_icon = "󰅖",
					modified_icon = "● ",
					close_icon = " ",
					left_trunc_marker = " ",
					right_trunc_marker = " ",
					-- 名称显示
					name_formatter = function(buf) -- buf: buffer对象
						-- 移除目录，只显示文件名
						local name = buf.name
						if name then
							name = vim.fn.fnamemodify(name, ":t")
						end
						return name
					end,
					max_name_length = 18,
					max_prefix_length = 15, -- 唯一性前缀长度
					truncate_names = true, -- 截断长文件名
					tab_size = 18,
					-- 颜色和样式
					diagnostics = "nvim_lsp", -- 可选: false | "nvim_lsp" | "coc"
					diagnostics_update_in_insert = false,
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,

					-- 偏移量（用于 NvimTree 等插件）
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							highlight = "Directory",
							text_align = "left",
						},
						{
							filetype = "neo-tree",
							text = "Neo-tree",
							highlight = "Directory",
							text_align = "left",
						},
						{
							filetype = "Outline",
							text = "Symbols",
							highlight = "Directory",
						},
					},

					-- 颜色图标
					color_icons = true,
					show_buffer_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,

					-- 分隔符样式
					separator_style = "thin", -- 可选: "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }

					-- 悬停
					hover = {
						enabled = true,
						delay = 200,
						reveal = { "close" },
					},

					-- 排序
					sort_by = "insert_after_current",
					-- 可选: 'insert_after_current' | 'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
					-- 自定义排序函数示例:
					-- sort_by = function(buffer_a, buffer_b)
					--   -- 按修改时间排序
					--   return buffer_a.modified > buffer_b.modified
					-- end,
				},
				-- 高亮配置（themable = true 时生效）
				highlights = {
					-- 当前活动 buffer 的文件名：亮青色 + 加粗
					buffer_selected = {
						fg = "#89dceb",
						bold = true,
						italic = false,
					},
					-- 非活动 buffer 的文件名：暗灰
					buffer_visible = {
						fg = "#6c7086",
						italic = false,
					},
				},
			})
		end,
	},
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

			-- 快捷键
			vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview", buffer = true })
			vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", { desc = "Stop preview", buffer = true })
			vim.keymap.set(
				"n",
				"<leader>mt",
				"<cmd>MarkdownPreviewToggle<CR>",
				{ desc = "Toggle preview", buffer = true }
			)
		end,
	},
	-- RGB彩色实时预览
	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" }, -- 延迟加载
		config = function()
			require("colorizer").setup({
				"*", -- 所有文件类型
			}, {
				RGB = true,
				RRGGBB = true,
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
			})

			-- 自动为所有文件启用
			vim.cmd("ColorizerAttachToBuffer")
		end,
	},
	-- cmdline的浮动显示，非必需，但是推荐
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim", -- 必须
		},
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

				notify = {
					enabled = false,
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
	-- 行内提示
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "ghost",
				options = {
					multilines = {
						enabled = true,
						always_show = true,
					},
					enable_on_select = true,

					virt_texts = {
						priority = 2048,
					},
				},
			})
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		end,
	},
	-- 更顺滑地窗口抖动
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy", -- 或 "BufReadPost"，按需触发
		opts = {
			-- 启用默认映射（可选）
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
			hide_cursor = true, -- 滚动时隐藏光标
			stop_eof = true, -- 到达文件末尾时停止
			respect_scrolloff = false,
			cursor_scrolls_alone = true,
			easing = "quadratic", -- 更自然的滚动效果
			performance_mode = false, -- 如遇卡顿可设为 true
			pre_hook = nil,
			post_hook = nil,
		},
		config = function(_, opts)
			require("neoscroll").setup(opts)
		end,
	},
}
