-- mason：管理 LSP / linter / formatter 等外部工具
return {
	"mason-org/mason.nvim",
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)

		-- 非 LSP 的工具（formatter 等）不在 mason-lspconfig 的 ensure_installed 里，
		-- 这里单独保证安装：shfmt 支持 bash/sh/zsh 三种方言，是 shell 的格式化器。
		local registry = require("mason-registry")
		for _, name in ipairs({ "shfmt" }) do
			local ok, pkg = pcall(registry.get_package, name)
			if ok and not pkg:is_installed() then
				pkg:install()
			end
		end
	end,
}
