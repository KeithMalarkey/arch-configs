-- mapleader setup
vim.g.mapleader = " "
vim.g.localmapleader = ","

-- 启动时注册为 nvim server，供 vimtex 反向搜索（zathura 点击 PDF 跳回源码）使用
if vim.fn.empty(vim.v.servername) == 1 then
	local sock = vim.fn.stdpath("run") .. "/nvim-" .. tostring(os.time()) .. ".sock"
	vim.fn.serverstart(sock)
end

-- polyfill for deprecated vim.tbl_flatten (used by many plugins)
if vim.tbl_flatten then
	local orig = vim.tbl_flatten
	vim.tbl_flatten = function(t)
		return vim.iter(t):flatten(math.huge):totable()
	end
end

require("keymap")
require("options")

-- lazy load
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
	-- 更新检查：定期 git fetch 检查插件更新（不会自动升级，升级仍需手动 :Lazy update）
	-- 有更新时不弹通知，打开 :Lazy 窗口可见标记
	checker = {
		enabled = true,
		frequency = 3600, -- 每小时检查一次
		check_plugins = true,
		notify = false,
	},
})

-- 默认启动主题设置
vim.cmd("colorscheme gruvbox")
