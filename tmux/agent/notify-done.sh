#!/usr/bin/env bash
# ~/.config/tmux/agent/notify-done.sh
# 在 tmux session 结束时调用，发送任务完成通知

SESSION_NAME="$1"
TASK_DESC="$2"

echo "$(date): notify-done called with $SESSION_NAME $TASK_DESC" >> /tmp/tmux-agent-notify.log

# 更新任务状态
WORKSPACE="$HOME/agent-workspace"
if [ -f "${WORKSPACE}/${SESSION_NAME}/.task.json" ]; then
  TASK_DESC=$(python3 -c "
import json
path = '${WORKSPACE}/${SESSION_NAME}/.task.json'
with open(path) as f:
    data = json.load(f)
    if data.get('status') == 'running':
        data['status'] = 'completed'
        data['completed'] = '$(date -Iseconds)'
        with open(path, 'w') as f:
            json.dump(data, f, indent=2)
    print(data.get('task', '$SESSION_NAME'))
" 2>/dev/null || echo "$SESSION_NAME")
fi

TASK_DESC="${TASK_DESC:-$SESSION_NAME}"

# 1. 桌面通知
notify-send \
  "Agent 任务完成" \
  "Session: ${SESSION_NAME}\nTask: ${TASK_DESC}" \
  -i utilities-terminal \
  -t 10000 \
  -u normal 2>/dev/null

# 2. tmux 广播消息到所有其他 session（忽略失败，因为可能没有活跃 session）
tmux display-message -d 5000 "[✓] Agent '${SESSION_NAME}' 完成: ${TASK_DESC}" 2>/dev/null || true

# 3. 终端铃声
printf '\a'
