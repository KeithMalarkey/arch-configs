#!/usr/bin/env bash
# ~/.config/tmux/agent/complete-session.sh
# 标记任务完成并触发通知
# 用法: complete-session.sh [session-name]

SESSION_NAME="${1:-$(tmux display-message -p '#{session_name}')}"
WORKSPACE="$HOME/agent-workspace"

if [ -f "${WORKSPACE}/${SESSION_NAME}/.task.json" ]; then
  # 更新状态文件
  python3 -c "
import json, sys
from datetime import datetime

path = '${WORKSPACE}/${SESSION_NAME}/.task.json'
with open(path, 'r') as f:
    data = json.load(f)
data['status'] = 'completed'
data['completed'] = datetime.now().isoformat()
with open(path, 'w') as f:
    json.dump(data, f, indent=2)
"
fi

# 触发通知
~/.config/tmux/agent/notify-done.sh "$SESSION_NAME" \
  "$(python3 -c "
import json
path = '${WORKSPACE}/${SESSION_NAME}/.task.json'
try:
    with open(path) as f:
        print(json.load(f).get('task', '$SESSION_NAME'))
except:
    print('$SESSION_NAME')
" 2>/dev/null || echo "$SESSION_NAME")
