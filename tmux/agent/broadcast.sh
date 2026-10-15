#!/usr/bin/env bash
# ~/.config/tmux/agent/broadcast.sh
# 向所有其他 agent session 广播消息
# 用法: broadcast.sh <message>
#       broadcast.sh --cmd <command>

MSG="$1"
shift

MODE=""
if [ "$MSG" = "--cmd" ]; then
  MODE="cmd"
  MSG="$1"
  shift
fi

# 获取所有 session（排除当前）
CURRENT=$(tmux display-message -p '#{session_name}')

for s in $(tmux list-sessions -F '#{session_name}'); do
  [ "$s" = "$CURRENT" ] && continue
  if [ "$MODE" = "cmd" ]; then
    tmux send-keys -t "$s" "$MSG" Enter
  else
    tmux send-keys -t "$s" "$MSG"
  fi
done

tmux display-message "已广播到所有 session: ${MSG}"
