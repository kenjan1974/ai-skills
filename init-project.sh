#!/bin/bash
# ╔════════════════════════════════════════════════════╗
# ║  新專案多代理環境快速初始化 (v1.1 — 已修正)        ║
# ║  用法：在專案根目錄執行 ~/ai-skills/init-project.sh ║
# ╚════════════════════════════════════════════════════╝
 
SKILLS_DIR="$HOME/ai-skills"
echo "🚀 初始化多代理開發環境..."
echo ""
 
# ── 0. .gitignore（最先建立，防止 node_modules 被 git 追蹤）──
if ! grep -q "node_modules" .gitignore 2>/dev/null; then
  cat >> .gitignore << 'GI'
# Dependencies
node_modules/
 
# AI Agent
.trees/
HANDOFF.md
.claude/settings.local.json
GI
  echo "  ✅ .gitignore（已加入 node_modules + AI agent 排除）"
else
  # 確保 AI agent 相關的排除也有加
  grep -q ".trees/" .gitignore || echo -e "\n.trees/" >> .gitignore
  grep -q "HANDOFF.md" .gitignore || echo "HANDOFF.md" >> .gitignore
  echo "  ✅ .gitignore（已存在，已確認 AI agent 排除項目）"
fi
 
# ── 1. 指令檔 ──
if [ ! -f AGENTS.md ]; then
  cp "$SKILLS_DIR/templates/AGENTS.md.template" AGENTS.md
  echo "  ✅ AGENTS.md（⚠️ 請編輯填入專案資訊）"
else
  echo "  ⏭️  AGENTS.md 已存在，跳過"
fi
 
if [ ! -f TODO.md ]; then
  cp "$SKILLS_DIR/templates/TODO.md.template" TODO.md
  echo "  ✅ TODO.md"
else
  echo "  ⏭️  TODO.md 已存在，跳過"
fi
 
echo "# 代理交接紀錄（將在代理切換時更新）" > HANDOFF.md
echo "  ✅ HANDOFF.md"
 
# ── 2. Symlinks ──
if [ ! -L CLAUDE.md ]; then
  ln -sf AGENTS.md CLAUDE.md
  echo "  ✅ CLAUDE.md → AGENTS.md"
else
  echo "  ⏭️  CLAUDE.md symlink 已存在"
fi
 
if [ ! -L GEMINI.md ]; then
  ln -sf AGENTS.md GEMINI.md
  echo "  ✅ GEMINI.md → AGENTS.md"
else
  echo "  ⏭️  GEMINI.md symlink 已存在"
fi
 
# ── 3. MCP 設定 ──
if [ ! -f .mcp.json ]; then
  echo '{"mcpServers":{}}' > .mcp.json
  echo "  ✅ .mcp.json"
else
  echo "  ⏭️  .mcp.json 已存在"
fi
 
# ── 4. 安裝 Skills ──
echo ""
"$SKILLS_DIR/install.sh" project
 
# ── 5. Git Hooks ──
if [ -f package.json ]; then
  echo ""
  echo "📦 安裝 Git Hooks..."
 
  # 安裝依賴
  npm install --save-dev husky lint-staged @commitlint/cli @commitlint/config-conventional 2>/dev/null
 
  # 初始化 Husky
  npx husky init 2>/dev/null
 
  # pre-commit hook
  cat > .husky/pre-commit << 'HOOK'
npx lint-staged 2>/dev/null || true
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "🚫 禁止直接 commit 到 $BRANCH！請用 feature branch。"
  exit 1
fi
HOOK
 
  # commit-msg hook
  cat > .husky/commit-msg << 'HOOK'
npx --no -- commitlint --edit "$1" 2>/dev/null || true
HOOK
 
  # commitlint config
  if [ ! -f commitlint.config.js ]; then
    echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
    echo "  ✅ commitlint.config.js"
  fi
 
  # lint-staged config
  if ! grep -q "lint-staged" package.json 2>/dev/null; then
    node -e "
      const pkg = require('./package.json');
      pkg['lint-staged'] = {
        '*.{ts,tsx,js,jsx}': ['prettier --write'],
        '*.{json,md,css,html}': ['prettier --write']
      };
      require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
    " 2>/dev/null && echo "  ✅ lint-staged 設定已加入 package.json"
  fi
 
  echo "  ✅ Git Hooks (Husky)"
fi
 
# ── 6. 完成摘要 ──
echo ""
echo "══════════════════════════════════════════"
echo "  🎉 初始化完成！"
echo ""
echo "  下一步："
echo "  1. 編輯 AGENTS.md，填入你的專案資訊"
echo "  2. 編輯 .mcp.json，加入需要的 MCP server"
echo "  3. 第一次 commit（用 --no-verify 因為是全新 repo）："
echo ""
echo "     git add -A"
echo "     git commit --no-verify -m 'chore: 初始化多代理開發環境'"
echo ""
echo "  4. 之後的 commit 就會自動觸發 hooks 了！"
echo "  5. 啟動代理：ai-claude / ai-codex / ai-gemini"
echo "  6. 檢查環境：ai-status"
echo "══════════════════════════════════════════"
