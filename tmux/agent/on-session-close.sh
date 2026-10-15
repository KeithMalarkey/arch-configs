#!/usr/bin/env bash
# ~/.config/tmux/agent/on-session-close.sh
# session 关闭时调用，检查哪些 agent session 已消失并发送通知

WORKSPACE="$HOME/agent-workspace"
[ -d "$WORKSPACE" ] || exit 0

# 获取当前所有活跃的 session 名称
ACTIVE_SESSIONS=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

# 检查所有 agent workspace 目录
for dir in "${WORKSPACE}"/agent-* "${WORKSPACE}"/codex-*; do
  [ -d "$dir" ] || continue

  SESSION_NAME=$(basename "$dir")
  ALIVE_FILE="${dir}/.alive"

  # 跳过已完成通知的 session
  [ -f "${dir}/.notified" ] && continue

  # 检查 session 是否还在活跃列表中
  if ! echo "$ACTIVE_SESSIONS" | grep -qx "$SESSION_NAME"; then
    # Session 已关闭，发送通知
    TASK_DESC="no description"
    if [ -f "${dir}/.task.json" ]; then
      TASK_DESC=$(python3 -c "
import json
with open('${dir}/.task.json') as f:
    data = json.load(f)
    if data.get('status') == 'running':
        data['status'] = 'completed'
        data['completed'] = '$(date -Iseconds)'
        with open('${dir}/.task.json', 'w') as f:
            json.dump(data, f, indent=2)
    print(data.get('task', '$SESSION_NAME'))
" 2>/dev/null || echo "$SESSION_NAME")
    fi

    # 桌面通知
    notify-send \
      "Agent 任务完成" \
      "Session: ${SESSION_NAME}\nTask: ${TASK_DESC}" \
      -i utilities-terminal \
      -t 10000 \
      -u normal 2>/dev/null

    # tmux 广播
    tmux display-message -d 5000 "[✓] Agent '${SESSION_NAME}' 完成: ${TASK_DESC}" 2>/dev/null || true

    # 终端铃声
    printf '\a'

    # 标记已通知，避免重复
    touch "${dir}/.notified"
  fi
done
