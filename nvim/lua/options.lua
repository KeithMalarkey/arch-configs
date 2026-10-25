vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- 添加 '-' 词语, deep-mind算一个词更合理
vim.opt.iskeyword:append("-")
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number" -- 开启光标行高亮,只高亮行号

-- 配置 swapfile 行为
-- 不要自动删除交换文件：文件被外部工具更新时，可能误删另一个 nvim
-- 正在使用的 swap，导致未保存内容静默丢失。交给 Neovim 自己提示。
vim.opt.swapfile = true

-- 设置 swapfile 目录
local swap_dir = vim.fn.stdpath("data") .. "/swap"
if vim.fn.isdirectory(swap_dir) == 0 then
	vim.fn.mkdir(swap_dir, "p")
end
vim.opt.directory = swap_dir .. "//" -- 双斜杠确保唯一文件名

vim.o.modeline = false -- 禁用模式行,一旦执行模式行后果不可预测
