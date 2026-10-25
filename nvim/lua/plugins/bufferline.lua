return {
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
		-- devicons 集中在 deps.lua，由 require 自动加载兜底
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
}
