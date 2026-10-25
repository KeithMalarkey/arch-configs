-- 公共依赖：被多个插件使用的库，集中在这里声明一次。
-- 其它插件不再写 dependencies —— lazy.nvim 在运行时第一次 require() 某模块时
-- 会自动加载提供它的插件（连同 config），散落的依赖声明只影响加载时机，
-- 删掉后由 require 自动加载兜底；但每个插件必须至少有一处声明，
-- 否则 lazy 不再认识它（所以集中到这个文件里，而不是全删）。
return {
	-- plenary：neo-tree、nvim-lsp-file-operations、todo-comments、lazygit、mesone 使用
	{ "nvim-lua/plenary.nvim" },
	-- 图标：lualine、bufferline、aerial、neo-tree、blink.cmp(lspkind) 使用
	{ "nvim-tree/nvim-web-devicons" },
	-- UI 组件库：noice、neo-tree 使用
	{ "MunifTanjim/nui.nvim" },
	-- telescope：mesone 的选择器、pdfreader 的 pickers 使用（fzf-lua 已接管日常搜索，
	-- 这里 lazy = true：不主动加载，只在被 require 时按需加载）
	{ "nvim-telescope/telescope.nvim", lazy = true },
}
