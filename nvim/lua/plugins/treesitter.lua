-- 语法高亮及解析，很重要，作为很多插件的依赖，建议放在顶部优先load,设置优先级priority
return {
	"nvim-treesitter/nvim-treesitter",
	-- 启动时立即加载：treesitter 要尽早注册 parser 并注入，
	-- 保证打开文件时立刻就有语法高亮（这里不用 event，lazy = false 时它也不生效）
	lazy = false,
	build = ":TSUpdate",
	-- dependencies = {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	"nvim-treesitter/nvim-treesitter-refactor",
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- },
	config = function()
		require("nvim-treesitter").setup({
			auto_install = true, -- 缺少解析器时自动安装
			modules = {}, -- 默认为空即可
			sync_install = false, -- 同步安装关闭
			ignore_install = {}, -- 忽略的语言列表
		})
	end,
	priority = 1000,
}
