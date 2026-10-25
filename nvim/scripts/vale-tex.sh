#!/usr/bin/env bash
# 给 nvim-lint 用的 vale 包装器：
#   1. 从 stdin 读入 .tex 内容
#   2. 用 texplain 剥掉 LaTeX 命令/数学环境，只留散文（行号保持 1:1）
#   3. 交给 vale 检查拼写/术语，输出 file:line:col:message 格式
#
# 为什么不用 vale 直接检查 .tex：
#   vale 没有 LaTeX 解析器（官方 issue #54 标记为 Won't Fix），
#   对 .tex 会按纯文本处理，\setbeamercolor{fg = white}、$a_n$ 这类
#   命令参数和数学符号都会被当成拼写错误。
set -uo pipefail

# --- 定位可执行文件（nvim 的 PATH 里可能没有它们）---
find_bin() {
	local name="$1"
	shift
	if command -v "$name" >/dev/null 2>&1; then
		command -v "$name"
		return 0
	fi
	for candidate in "$@"; do
		if [ -x "$candidate" ]; then
			echo "$candidate"
			return 0
		fi
	done
	return 1
}

VALE_BIN=$(find_bin vale "$HOME/.local/share/nvim/mason/bin/vale" /usr/bin/vale) || {
	echo "vale-tex.sh: 找不到 vale 可执行文件" >&2
	exit 1
}
TEXPLAIN_BIN=$(find_bin texplain "$HOME/.cargo/bin/texplain" /usr/local/bin/texplain) || {
	echo "vale-tex.sh: 找不到 texplain 可执行文件" >&2
	exit 1
}

VALE_CONFIG="${VALE_CONFIG:-$HOME/.config/vale/.vale.ini}"

workdir=$(mktemp -d "${TMPDIR:-/tmp}/nvim-vale-XXXXXX")
trap 'rm -rf "$workdir"' EXIT

src="$workdir/input.tex"
out="$workdir/stripped.md"

cat >"$src"

# texplain 对不认识的命令会保留花括号里的内容（比如
# \setbeamercolor*{palette secondary}{fg = white} 会留下 "fg = white"），
# 这里先把纯配置类的命令行清空（保持行数不变），避免它们被当成散文。
filtered="$workdir/filtered.tex"
sed -E "s#^[[:space:]]*\\\\(setbeamercolor|setbeamerfont|setbeamertemplate|definecolor|colorlet|geometry|hypersetup|usetheme|usecolortheme|useinnertheme|useoutertheme|setlength|setcounter|graphicspath|lstset|tikzset|pgfplotsset|newcommand|renewcommand|providecommand|DeclareMathOperator|setmainfont|setsansfont|setmonofont|setCJKmainfont|linespread|addbibresource|bibliography|author|date|institute)\*?([[:space:]]|\{|\[|\$).*# #" \
	"$src" >"$filtered"

# texplain 剥掉标记；失败时退回原文，至少还能查拼写
if ! "$TEXPLAIN_BIN" "$filtered" >"$out" 2>/dev/null; then
	cp "$src" "$out"
fi

# vale 在找不到配置时退出码是 2，这里不当作失败
# 输出只保留 "行:列:规则:消息"（去掉临时文件路径，否则 nvim-lint 会把它
# 解析成另一个 buffer 而丢弃诊断）
"$VALE_BIN" --config "$VALE_CONFIG" --output=line "$out" 2>/dev/null | cut -d: -f2- || true
