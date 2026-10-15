--配置具体的lsp for different language
return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			-- "hrsh7th/cmp-nvim-lsp",
			"glepnir/lspsaga.nvim",
			"folke/trouble.nvim",
			"j-hui/fidget.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- =================== capabilities ===================
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			-- if ok then
			--   capabilities = cmp_lsp.default_capabilities(capabilities)
			-- end

			-- local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- local capabilities = {}
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- =================== on_attach ===================
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)

				-- 开启 inlay hints
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end

			-- =================== C/C++ ===================
			vim.lsp.config["clangd"] = {
				cmd = {
					"clangd",
					"--background-index",
					"--suggest-missing-includes",
					"--clang-tidy",
					"--query-driver=/usr/bin/arm-none-eabi-gcc,/usr/bin/arm-none-eabi-g++",
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cc" },
				root_markers = { ".clangd", "compile_commands.json", "CMakeLists.txt", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("clangd")

			-- =================== CMake ===================
			vim.lsp.config["cmake"] = {
				cmd = { "neocmakelsp", "stdio" },
				filetypes = { "cmake" },
				root_markers = { ".git", "build", "cmake" },
				init_options = {
					buildDirectory = "build",
				},
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("neocmake")

			-- =================== Rust ===================
			vim.lsp.config["rust_analyzer"] = {
				cmd = { "rust_analyzer" },
				on_attach = on_attach,
				filetypes = { "rust" },
				capabilities = capabilities,
				root_markers = { "Cargo.toml", "rust-project.json", ".git" },
			}
			vim.lsp.enable("rust_analyzer")

			-- =================== Python ===================
			vim.lsp.config["pyright"] = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = {
					"pyrightconfig.json",
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					".git",
				},
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						pythonPath = ".venv/bin/python", -- ⭐ 关键
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							reportAttributeAccessIssue = "none", -- ⭐ 解决 tf.keras
						},
					},
				},
			}
			vim.lsp.enable("pyright")

			-- =================== Lua ===================
			vim.lsp.config["lua_ls"] = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".git", "lua" },
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = {
								vim.fn.stdpath("config"),
								vim.fn.stdpath("data") .. "/lazy",
								vim.api.nvim_get_runtime_file("", true),
							},
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			}
			vim.lsp.enable("lua_ls")

			-- =================== Bash ===================
			vim.lsp.config["bashls"] = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash", "make", "zsh" },
				root_markers = { ".git", ".bashrc", ".zshrc", "Makefile", "Dockerfile" },
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("bashls")

			-- =================== Vim ====================
			vim.lsp.config["vimls"] = {
				cmd = { "vun-language-server", "--stdio" },
				filetypes = { "vim" },
				root_markers = { ".git", ".nvim" },
				on_attach = on_attach,
				capabilities = capabilities,
			}
			vim.lsp.enable("vimlsh")

			-- =================== Java ====================
			vim.lsp.config["jdtls"] = {
				cmd = "jdtls",
				filetypes = { "java", "class" },
				root_markers = {
					{ "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" },
					{ "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" },
				},
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("jdtls")

			-- =================== Yaml ====================
			vim.lsp.config["yamlls"] = {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
				root_markers = { ".git" },
				on_attach = on_attach,
				capabilities = capabilities,
			}
			vim.lsp.enable("yamlls")

			-- =================== Zig ====================
			vim.lsp.config["zls"] = {
				cmd = { "zls" },
				filetypes = { "zig", "zir" },
				root_markers = { "zls.json", "build.zig", ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
				workspace_required = false,
			}
			vim.lsp.enable("zls")

			-- =================== Json ====================
			vim.lsp.config["jsonls"] = {
				cmd = { "vscode-json-language-server", "--stdio" },
				filetypes = { "json", "jsonc" },
				root_markers = { ".git" },
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("jsonls")

			-- =================== HTML ===================
			-- vim.lsp.config["html"] = {
			-- cmd = { "vscode-html-language-server", "--stdio" },
			-- filetypes = { "html" },
			-- capabilities = capabilities,
			-- on_attach = on_attach,
			-- }
			-- vim.lsp.enable("html")

			-- =================== CSS ===================
			-- vim.lsp.config["cssls"] = {
			-- cmd = { "vscode-css-language-server", "--stdio" },
			-- filetypes = { "css", "scss", "less" },
			-- capabilities = capabilities,
			-- on_attach = on_attach,
			-- }
			-- vim.lsp.enable("cssls")

			-- =================== JavaScript/TypeScript ===================
			-- vim.lsp.config["tsserver"] = {
			-- cmd = { "typescript-language-server", "--stdio" },
			-- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			-- capabilities = capabilities,
			-- on_attach = on_attach,
			-- }
			-- vim.lsp.enable("tsserver")

			vim.lsp.config["tex"] = {
				cmd = { "ltex-ls" },
				filetypes = {
					"bib",
					"gitcommit",
					"markdown",
					"org",
					"plaintex",
					"rst",
					"rnoweb",
					"tex",
					"pandoc",
					"quarto",
					"rmd",
					"context",
					"html",
					"xhtml",
					"mail",
					"text",
				},
				settings = {
					ltex = {
						enable = {
							"bibtex",
							"gitcommit",
							"markdown",
							"org",
							"tex",
							"restructuredtext",
							"rsweave",
							"latex",
							"quarto",
							"rmd",
							"context",
							"html",
							"xhtml",
							"mail",
							"plaintext",
						},
						language = "auto",
					},
				},
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("ltex")

			-- =================== lspsaga ===================
			require("lspsaga").setup({
				ui = { border = "rounded" },
				symbol_in_winbar = { enable = false },
				lightbulb = { enable = false, virtual_text = false },
			})

			-- =================== trouble ===================
			require("trouble").setup({
				win = { position = "bottom", height = 0.3 },
				icons = {
					error = "",
					warning = "",
					hint = "",
					information = "",
				},
				mode = "workspace_diagnostics",
				fold_open = "",
				fold_closed = "",
				action_keys = {
					close = "q",
					jump = { "<cr>", "<tab>" },
					refresh = "r",
				},
				use_diagnostic_signs = true,
			})
		end,
	},
}
