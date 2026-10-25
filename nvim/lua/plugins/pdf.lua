return {
	"r-pletnev/pdfreader.nvim",
	lazy = false,
	-- snacks 有自己的 spec、telescope 在 deps.lua：
	-- pdfreader 启动时 require("pdfreader.state") → pickers 会自动加载 telescope
	config = function()
		require("pdfreader").setup()
	end,
}
