#!/bin/bash
# ╔════════════════════════════════════════════╗
# ║  AI Skills 跨代理安裝腳本                  ║
# ║  用法：./install.sh [project|global]       ║
# ╚════════════════════════════════════════════╝
 
MODE=${1:-project}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
 
if [ "$MODE" = "global" ]; then
  CLAUDE_DIR="$HOME/.claude/skills"
  AGENTS_DIR="$HOME/.agents/skills"
  GEMINI_DIR="$HOME/.gemini/skills"
  echo "📦 全域安裝模式（所有專案通用）"
else
  CLAUDE_DIR=".claude/skills"
  AGENTS_DIR=".agents/skills"
  GEMINI_DIR=".gemini/skills"
  echo "📦 專案安裝模式（僅限目前專案）"
fi
 
mkdir -p "$CLAUDE_DIR" "$AGENTS_DIR" "$GEMINI_DIR"
 
INSTALLED=0
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  
  # 複製到 .agents/skills/（通用路徑，Codex CLI 等讀取）
  rm -rf "$AGENTS_DIR/$skill_name"
  cp -r "$skill_dir" "$AGENTS_DIR/$skill_name"
  
  # 為 Claude Code 建立 symlink（或複製）
  rm -rf "$CLAUDE_DIR/$skill_name"
  ln -sf "$(cd "$AGENTS_DIR" && pwd)/$skill_name" "$CLAUDE_DIR/$skill_name" 2>/dev/null || \
    cp -r "$skill_dir" "$CLAUDE_DIR/$skill_name"
  
  # 為 Gemini CLI 建立 symlink（或複製）
  rm -rf "$GEMINI_DIR/$skill_name"
  ln -sf "$(cd "$AGENTS_DIR" && pwd)/$skill_name" "$GEMINI_DIR/$skill_name" 2>/dev/null || \
    cp -r "$skill_dir" "$GEMINI_DIR/$skill_name"
  
  INSTALLED=$((INSTALLED + 1))
  echo "  ✅ $skill_name"
done
 
echo ""
echo "══════════════════════════════════"
echo "  安裝完成！共 $INSTALLED 個 skills"
echo "  Claude Code : $CLAUDE_DIR"
echo "  Codex CLI   : $AGENTS_DIR"
echo "  Gemini CLI  : $GEMINI_DIR"
echo "══════════════════════════════════"
