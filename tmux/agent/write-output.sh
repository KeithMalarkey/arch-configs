#!/usr/bin/env bash
# ~/.config/tmux/agent/write-output.sh
# 将中间产物写入 workspace，供其他 session 读取
# 用法: write-output.sh <session-name> <artifact-name> <content-or-file>

SESSION_NAME="$1"
ARTIFACT="$2"
CONTENT="${3:--}"
WORKSPACE="$HOME/agent-workspace"

if [ "$CONTENT" = "-" ]; then
  # 从 stdin 读取
  cat > "${WORKSPACE}/${SESSION_NAME}/outputs/${ARTIFACT}"
else
  if [ -f "$CONTENT" ]; then
    cp "$CONTENT" "${WORKSPACE}/${SESSION_NAME}/outputs/${ARTIFACT}"
  else
    echo "$CONTENT" > "${WORKSPACE}/${SESSION_NAME}/outputs/${ARTIFACT}"
  fi
fi

echo "Artifact '${ARTIFACT}' written to ${WORKSPACE}/${SESSION_NAME}/outputs/"
