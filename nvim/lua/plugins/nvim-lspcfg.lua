--配置具体的lsp for different language
return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		-- lspsaga / trouble 没有独立 spec，保留依赖声明（config 里 require 也会自动加载）；
		-- fidget 已从配置中移除、blink.cmp 有自己的顶层 spec，都不再声明
		dependencies = {
			-- "hrsh7th/cmp-nvim-lsp",
			"glepnir/lspsaga.nvim",
			"folke/trouble.nvim",
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
			vim.lsp.config["neocmake"] = {
				cmd = { "neocmakelsp", "stdio" },
				filetypes = { "cmake" },
				root_markers = { ".neocmake.toml", ".git", "build", "cmake" },
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
			-- bashls 只负责 bash/sh，zsh 交给 shuck（bash-language-server 不认识 zsh 语法）
			vim.lsp.config["bashls"] = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash", "make" },
				root_markers = { ".git", ".bashrc", ".zshrc", "Makefile", "Dockerfile" },
				capabilities = capabilities,
				on_attach = on_attach,
			}
			vim.lsp.enable("bashls")

			-- =================== Zsh ===================
			-- shuck：支持 bash/zsh/posix/mksh 方言的 LSP，zsh 语法、诊断、补全都更准
			-- 这里只接管 zsh，bash/sh 仍由 bashls 处理，避免同一 buffer 出现两份诊断
			vim.lsp.config["shuck"] = {
				cmd = { "shuck", "server" },
				filetypes = { "zsh" },
				root_markers = { ".shuck.toml", ".git" },
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					-- shuck 的诊断走 pull 协议，会和 nvim-lint 的 shuck linter 重复显示。
					-- 这里直接去掉它的 diagnosticProvider 能力，nvim 就不会再为它
					-- 注册 pull 诊断命名空间，诊断统一交给 nvim-lint（用的是缓冲区最新内容）。
					client.server_capabilities.diagnosticProvider = nil
				end,
			}
			vim.lsp.enable("shuck")

			-- =================== Vim ====================
			vim.lsp.config["vimls"] = {
				cmd = { "vim-language-server", "--stdio" },
				filetypes = { "vim" },
				root_markers = { ".git", ".nvim" },
				on_attach = on_attach,
				capabilities = capabilities,
			}
			vim.lsp.enable("vimls")

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

			-- =================== LaTeX ===================
			-- TexLab：LaTeX 结构分析（补全 \command、label/\ref 跳转、括号配对、环境补全）
			-- 不依赖 Java，纯 Rust 二进制，毫秒级响应
			local function texlab_on_attach(client, bufnr)
				on_attach(client, bufnr)

				-- TexLab 的自定义命令（覆盖 nvim-lspconfig 默认的 on_attach，
				-- 因为这里指定了自己的 on_attach，默认那些就没了）
				local win = vim.api.nvim_get_current_win()
				local function pos_params()
					return vim.lsp.util.make_position_params(win, client.offset_encoding)
				end

				vim.api.nvim_buf_create_user_command(bufnr, "LspTexlabBuild", function()
					client:request("textDocument/build", pos_params(), function(err, result)
						if err then
							vim.notify(tostring(err), vim.log.levels.ERROR)
							return
						end
						local status = {
							[0] = "成功",
							[1] = "有错误",
							[2] = "失败",
							[3] = "已取消",
						}
						vim.notify("TexLab 编译: " .. (status[result.status] or "未知"), vim.log.levels.INFO)
					end, bufnr)
				end, { desc = "用 TexLab 编译当前文件" })

				vim.api.nvim_buf_create_user_command(bufnr, "LspTexlabForward", function()
					client:request("textDocument/forwardSearch", pos_params(), function(err, result)
						if err then
							vim.notify(tostring(err), vim.log.levels.ERROR)
							return
						end
						local status = {
							[0] = "成功",
							[1] = "有错误",
							[2] = "失败",
							[3] = "未配置 forwardSearch",
						}
						vim.notify("正向搜索: " .. (status[result.status] or "未知"), vim.log.levels.INFO)
					end, bufnr)
				end, { desc = "从光标位置正向搜索到 PDF (zathura)" })

				vim.api.nvim_buf_create_user_command(bufnr, "LspTexlabFindEnvironments", function()
					client:exec_cmd({
						command = "texlab.findEnvironments",
						arguments = { pos_params() },
					}, { bufnr = bufnr }, function(err, result)
						if err then
							vim.notify(tostring(err), vim.log.levels.ERROR)
							return
						end
						local names = {}
						for _, env in ipairs(result) do
							table.insert(names, env.name.text)
						end
						vim.lsp.util.open_floating_preview(names, "", {
							height = #names,
							width = math.max(#names, 12),
							focusable = false,
							focus = false,
							title = "Environments",
						})
					end)
				end, { desc = "列出当前位置可用的 LaTeX 环境" })

				vim.api.nvim_buf_create_user_command(bufnr, "LspTexlabCleanArtifacts", function()
					client:exec_cmd({
						command = "texlab.cleanArtifacts",
						arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
					}, { bufnr = bufnr }, function(err)
						if err then
							vim.notify(tostring(err), vim.log.levels.ERROR)
							return
						end
						vim.notify("已清理编译产物", vim.log.levels.INFO)
					end)
				end, { desc = "清理 LaTeX 编译产物" })

				vim.api.nvim_buf_create_user_command(bufnr, "LspTexlabCleanAuxiliary", function()
					client:exec_cmd({
						command = "texlab.cleanAuxiliary",
						arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
					}, { bufnr = bufnr }, function(err)
						if err then
							vim.notify(tostring(err), vim.log.levels.ERROR)
							return
						end
						vim.notify("已清理辅助文件", vim.log.levels.INFO)
					end)
				end, { desc = "清理 LaTeX 辅助文件 (aux/log) " })
			end

			vim.lsp.config["texlab"] = {
				cmd = { "texlab" },
				filetypes = { "tex", "plaintex", "bib" },
				-- 默认的 root_markers 找不到时（比如单个 .tex 文件）root_dir 会是 nil，
				-- texlab 就无法解析 \ref / \include 的跨文件引用。
				-- 这里自己实现：优先用 marker 目录，找不到就退回文件所在目录。
				root_dir = function(bufnr, on_dir)
					local markers = {
						".git",
						".latexmkrc",
						"latexmkrc",
						".texlabroot",
						"texlabroot",
						"Tectonic.toml",
					}
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local dir = vim.fs.dirname(fname)
					if dir and dir ~= "" then
						for _, marker in ipairs(markers) do
							local found = vim.fs.find(marker, { path = dir, upward = true })[1]
							if found then
								on_dir(vim.fs.dirname(found))
								return
							end
						end
						on_dir(dir)
						return
					end
					on_dir()
				end,
				settings = {
					texlab = {
						-- 编译：和 vimtex 保持一致，用 xelatex（fontspec 需要）
						build = {
							executable = "latexmk",
							args = {
								"-xelatex",
								"-shell-escape",
								"-file-line-error",
								"-synctex=1",
								"-interaction=nonstopmode",
							},
							onSave = false,
							forwardSearchAfter = false,
						},
						-- 正向搜索：从 .tex 跳到 zathura 里的对应位置
						forwardSearch = {
							executable = "zathura",
							args = { "--synctex-forward" },
						},
						-- 格式化交给 conform 的 tex-fmt，这里关掉避免两边抢
						latexFormatter = "none",
						bibtexFormatter = "none",
						-- chktex 保持关闭，编译错误由 latexmk 报
						chktex = {
							onOpenAndSave = false,
							onEdit = false,
						},
						diagnosticsDelay = 300,
					},
				},
				capabilities = capabilities,
				on_attach = texlab_on_attach,
			}
			vim.lsp.enable("texlab")

			-- =================== TOML ===================
			vim.lsp.config["tombi"] = {
				cmd = { "tombi", "lsp" },
				filetypes = { "toml" },
				root_markers = { "tombi.toml", "pyproject.toml", ".git" },
			}
			vim.lsp.enable("tombi")

			-- =================== LTeX（英文语法检查，暂时禁用）===================
			-- LTeX 用 LanguageTool 检查英文语法/拼写，和 TexLab 是互补的。
			-- 但当前 ltex-ls 16 + Java 27 不兼容，会持续报
			-- "Could not activate rules"，lsp.log 会被刷到 100MB+，
			-- 所以先禁用；等升级 ltex-ls 或换兼容的 JDK 后再打开。
			vim.lsp.config["ltex"] = {
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
			-- vim.lsp.enable("ltex")

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
