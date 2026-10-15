#!/usr/bin/env bash
# ~/.config/tmux/agent/send-to-session.sh
# 从当前 session 向目标 session 发送消息/命令
# 用法: send-to-session.sh <target-session> <message>
#       send-to-session.sh <target-session> --cmd <command>

TARGET="$1"
shift

# 检查目标 session 是否存在
if ! tmux has-session -t "$TARGET" 2>/dev/null; then
  echo "Error: session '${TARGET}' does not exist"
  exit 1
fi

if [ "$1" = "--cmd" ]; then
  shift
  # 发送命令到目标 session 的第一个 pane
  tmux send-keys -t "$TARGET" "$*" Enter
  tmux display-message "已发送命令到 '${TARGET}': $*"
else
  # 发送文本消息
  tmux send-keys -t "$TARGET" "$*"
  tmux display-message "已发送消息到 '${TARGET}': $*"
fi
