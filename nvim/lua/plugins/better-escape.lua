-- 快速退出 normal 模式的插件
return {
	"max397574/better-escape.nvim",
	event = "InsertEnter",
	config = function()
		require("better_escape").setup()
	end,
}
