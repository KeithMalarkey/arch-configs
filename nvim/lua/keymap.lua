vim.keymap.set({ "n", "v" }, "<C-q>", "<cmd>q!<CR>", { desc = "Force quit" })
vim.keymap.set({ "n", "v" }, "<C-s>", "<cmd>wall<CR>", { desc = "Force write all" })
vim.keymap.set("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set("n", "<leader>R", function()
	local old_name = vim.fn.expand("%:p")
	if old_name == "" then
		vim.notify("当前缓冲区无文件", vim.log.levels.WARN)
		return
	end
	vim.ui.input({ prompt = "New File Name: ", default = old_name }, function(new_name)
		if new_name and new_name ~= "" and new_name ~= old_name then
			vim.cmd("saveas " .. vim.fn.fnameescape(new_name))
			vim.cmd("silent! !rm " .. vim.fn.shellescape(old_name))
			vim.cmd("e!") -- 重新加载
			vim.notify("文件已重命名为: " .. new_name)
		end
	end)
end, { desc = "Rename Current File" })

--[[ Tab/Win/Buf(win或者split的操作参见smart_split的config) ]]
-- space c 关闭窗口,或buffer
vim.keymap.set("n", "<leader>c", function()
	local current_buf = vim.api.nvim_get_current_buf()
	local wins = vim.tbl_filter(function(win)
		return vim.api.nvim_win_get_buf(win) == current_buf
	end, vim.api.nvim_list_wins())

	if #wins <= 1 then
		vim.cmd("bd")
	else
		vim.cmd("close")
	end
end, { desc = "Close window/split or buffer" })
-- 关闭所有缓冲区
vim.keymap.set("n", "<leader>cb", "<cmd>%bd<cr>", { desc = "close all buffers" })
-- 切换buffer
vim.keymap.set("n", "[b", "<cmd>bp<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "]b", "<cmd>bn<cr>", { desc = "Next Buffer" })
-- 切换窗口
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w>h", { desc = "go to the left window/split" })
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w>l", { desc = "go to the right window/split" })
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w>j", { desc = "go to the down window/split" })
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w>k", { desc = "go to the up window/split" })
-- 分割窗口
vim.keymap.set({ "n", "v" }, "<leader>|", "<cmd>vsplit<CR>", {
	desc = "vertical split",
})
vim.keymap.set({ "n", "v" }, "<leader>\\", "<cmd>split<CR>", {
	desc = "horizontal split",
})
-- 调整窗口大小
local function resize_window(direction)
	local win = vim.api.nvim_get_current_win()
	local config = vim.api.nvim_win_get_config(win)

	if direction == "left" then
		vim.cmd("vertical resize -2")
	elseif direction == "right" then
		vim.cmd("vertical resize +2")
	elseif direction == "up" then
		vim.cmd("resize -2")
	elseif direction == "down" then
		vim.cmd("resize +2")
	end
end
vim.keymap.set("n", "<C-Left>", function()
	resize_window("left")
end, { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", function()
	resize_window("right")
end, { desc = "Increase window width" })
vim.keymap.set("n", "<C-Up>", function()
	resize_window("up")
end, { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Down>", function()
	resize_window("down")
end, { desc = "Increase window height" })

vim.keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next [T]ab" }) -- 下一个tab
vim.keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous [T]ab" }) -- 前一个tab
vim.keymap.set("n", "<C-t>n", "<cmd>tabnew<cr>", { desc = "[T]ab [N]ew" })
vim.keymap.set("n", "<C-t>c", "<cmd>tabclose<cr>", { desc = "[T]ab [C]lose" })

-- neotree
-- vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" }) # 同下
vim.keymap.set("n", "<leader>on", "<cmd>Neotree focus<cr>", { desc = "Focus Neotree" })

local function neotree_toggle_current()
	local buf_path = vim.api.nvim_buf_get_name(0) -- 获取当前 buffer 路径
	local dir_path

	if buf_path == "" then
		-- 如果是新建的 buffer，使用当前工作目录
		dir_path = vim.fn.getcwd()
	else
		-- 获取当前文件所在目录
		dir_path = vim.fn.fnamemodify(buf_path, ":h")
	end

	-- 使用 neotree 打开该目录
	require("neo-tree.command").execute({
		toggle = true,
		dir = dir_path,
	})
end
vim.keymap.set("n", "<leader>fe", neotree_toggle_current, { desc = "Neotree (current buffer dir)" }) -- 打开当前buffer的根目录

-- themes
-- vim.keymap.set("n", "<leader>ft", "<cmd>Telescope colorscheme<CR>", { desc = " Find Installed Themes" })
vim.keymap.set("n", "<leader>ft", function()
	require("fzf-lua").fzf_exec(vim.fn.getcompletion("", "color"), {
		actions = {
			["default"] = function(selected)
				vim.cmd("colorscheme " .. selected[1])
			end,
		},
	})
end, { desc = "switch colorscheme" })
vim.keymap.set(
	"n",
	"<leader>fh",
	"<cmd>FzfLua combine oldfiles git_files<cr>",
	{ desc = "find recent history files and git files" }
)

-- lsp enhancement
vim.keymap.set("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "go to definition" })
vim.keymap.set("n", "gD", function()
	vim.lsp.buf.declaration()
end, { desc = "go to declaration" })
vim.keymap.set("n", "gi", function()
	vim.lsp.buf.implementation()
end, { desc = "go to implementation" })
vim.keymap.set("n", "gr", function()
	vim.lsp.buf.references()
end, { desc = "go to references" })
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover()
end, { desc = "Hover" })
vim.keymap.set("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end, { desc = "rename" })
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "code action" })
