-- 语言服务器
return {
	"mason-org/mason-lspconfig.nvim",
	event = "BufEnter",
	opts = {
		ensure_installed = {
			"lua_ls",
			"rust_analyzer",
			"clangd",
			"pyright",
			"zls",
			"neocmake",
			"jsonls",
			"yamlls",
			"ltex",
			"jdtls",
			"shuck",
			"texlab",
		},
		automatic_enable = false,
	},
	-- mason 和 nvim-lspconfig 都有自己的顶层 spec（config 里 require 时自动加载），无需声明依赖
}
