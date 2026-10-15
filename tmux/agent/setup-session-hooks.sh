#!/usr/bin/env bash
# ~/.config/tmux/agent/setup-session-hooks.sh
# 在 new session 后被调用，初始化 workspace 并注册 session-closed hook

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

# 2. 为该 session 注册专属的 session-closed hook（session 名已硬编码）
tmux set-hook -t "$SESSION_NAME" session-closed "run-shell '$HOME/.config/tmux/agent/notify-done.sh $SESSION_NAME'"
