return {
	"marc0x71/mesone.nvim",
	-- 按需加载：:Mesone 命令（由插件 plugin/ 文件定义）或 <leader>m* 触发，
	-- 不再 lazy=false 启动加载 —— 顺带 nvim-dap 也不再在启动时加载
	cmd = "Mesone",
	opts = {
		build_folder = "build",
		build_type = "debugoptimized",
		dap_adapter = "gdb",
		show_command_logs = false,
		auto_compile = true,
		auto_close_terminal = false,
		compile_before_run = false,
	},
	-- 只保留 nvim-dap：它没有独立 spec；fidget 已移除，telescope / plenary 集中在 deps.lua
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	keys = {
		{ "<leader>mi", "<cmd>Mesone init<cr>", desc = "Initialize Mesone" },
		{ "<leader>ms", "<cmd>Mesone setup<cr>", desc = "Initialize Meson project" },
		{ "<leader>mc", "<cmd>Mesone compile<cr>", desc = "Compile project" },
		{ "<leader>mt", "<cmd>Mesone test<cr>", desc = "Show tests" },
		{ "<leader>mr", "<cmd>Mesone run<cr>", desc = "Run target" },
		{ "<leader>md", "<cmd>Mesone debug<cr>", desc = "Debug target" },
		{ "<leader>ml", "<cmd>Mesone log<cr>", desc = "Show last log" },
		{ "<leader>mC", "<cmd>Mesone clean<cr>", desc = "Clean" },
		{ "<leader>mS", "<cmd>Mesone setting<cr>", desc = "Project settings" },
	},
}
