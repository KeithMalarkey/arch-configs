#!/usr/bin/env bash
# ~/.config/tmux/agent/init-session.sh
# 创建新的 agent session 时初始化工作目录和状态文件
# 用法: init-session.sh <session-name> [task-description]

SESSION_NAME="$1"
TASK_DESC="${2:-no description}"

# 只对 agent/codex 前缀的 session 生效
if ! [[ "$SESSION_NAME" =~ ^(agent-|codex-|agent[0-9]) ]]; then
    exit 0
fi

WORKSPACE="$HOME/agent-workspace"

mkdir -p "${WORKSPACE}/${SESSION_NAME}/outputs"

# 创建任务状态文件
cat > "${WORKSPACE}/${SESSION_NAME}/.task.json" << EOF
{
  "session": "${SESSION_NAME}",
  "task": "${TASK_DESC}",
  "status": "running",
  "created": "$(date -Iseconds)",
  "completed": null,
  "outputs": []
}
EOF

# 创建共享消息目录（用于 session 间通信）
mkdir -p "${WORKSPACE}/shared/messages"
