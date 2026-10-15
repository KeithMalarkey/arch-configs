#!/usr/bin/env bash
# ~/.config/tmux/agent/setup-session.sh
# 在 new session 后被调用

SESSION_NAME="$1"

# 只对 agent/codex 前缀的 session 生效
if ! [[ "$SESSION_NAME" =~ ^(agent-|codex-|agent[0-9]) ]]; then
  exit 0
fi

WORKSPACE="$HOME/agent-workspace"

# 1. 初始化工作目录
mkdir -p "${WORKSPACE}/${SESSION_NAME}/outputs"
mkdir -p "${WORKSPACE}/shared/messages"

cat > "${WORKSPACE}/${SESSION_NAME}/.task.json" << EOF
{
  "session": "${SESSION_NAME}",
  "task": "no description",
  "status": "running",
  "created": "$(date -Iseconds)",
  "completed": null,
  "outputs": []
}
EOF

# 2. 创建 session 活跃标记文件
touch "${WORKSPACE}/${SESSION_NAME}/.alive"
