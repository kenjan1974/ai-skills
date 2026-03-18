#!/bin/bash
# ╔════════════════════════════════════════════════╗
# ║  新專案多代理環境快速初始化                     ║
# ║  用法：在專案根目錄執行 ~/ai-skills/init-project.sh ║
# ╚════════════════════════════════════════════════╝
 
SKILLS_DIR="$HOME/ai-skills"
echo "🚀 初始化多代理開發環境..."
 
# 1. 複製範本
[ ! -f AGENTS.md ] && cp "$SKILLS_DIR/templates/AGENTS.md.template" AGENTS.md && echo "  ✅ AGENTS.md（請編輯內容）"
[ ! -f TODO.md ] && cp "$SKILLS_DIR/templates/TODO.md.template" TODO.md && echo "  ✅ TODO.md"
echo "# 代理交接紀錄（將在代理切換時更新）" > HANDOFF.md && echo "  ✅ HANDOFF.md"
 
# 2. Symlinks
[ ! -L CLAUDE.md ] && ln -sf AGENTS.md CLAUDE.md && echo "  ✅ CLAUDE.md → AGENTS.md"
[ ! -L GEMINI.md ] && ln -sf AGENTS.md GEMINI.md && echo "  ✅ GEMINI.md → AGENTS.md"
 
# 3. MCP 設定
[ ! -f .mcp.json ] && echo '{"mcpServers":{}}' > .mcp.json && echo "  ✅ .mcp.json"
 
# 4. 安裝 Skills
"$SKILLS_DIR/install.sh" project
 
# 5. Git Hooks（如果有 package.json）
if [ -f package.json ]; then
  echo ""
  echo "📦 安裝 Git Hooks..."
  npm install --save-dev husky lint-staged @commitlint/cli @commitlint/config-conventional 2>/dev/null
  npx husky init 2>/dev/null
 
  # pre-commit
  cat > .husky/pre-commit << 'HOOK'
npx lint-staged 2>/dev/null || true
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo "🚫 禁止直接 commit 到 $BRANCH！請用 feature branch。"
  exit 1
fi
HOOK
 
  # commit-msg
  cat > .husky/commit-msg << 'HOOK'
npx --no -- commitlint --edit "$1" 2>/dev/null || true
HOOK
 
  # commitlint config
  [ ! -f commitlint.config.js ] && echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
 
  # lint-staged config（如果還沒有的話）
  if ! grep -q "lint-staged" package.json; then
    # 用 node 安全地加入 lint-staged 設定
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
 
# 6. .gitignore 更新
if ! grep -q ".trees/" .gitignore 2>/dev/null; then
  cat >> .gitignore << 'GI'
 
# AI Agent
.trees/
HANDOFF.md
.claude/settings.local.json
GI
  echo "  ✅ .gitignore 更新"
fi
 
echo ""
echo "══════════════════════════════════════════"
echo "  🎉 初始化完成！"
echo ""
echo "  下一步："
echo "  1. 編輯 AGENTS.md，填入你的專案資訊"
echo "  2. 編輯 .mcp.json，加入需要的 MCP server"
echo "  3. git add -A && git commit -m 'chore: 初始化多代理開發環境'"
echo "  4. 啟動任何代理開始工作："
echo "     ai-claude / ai-codex / ai-gemini"
echo "  5. 用 ai-status 檢查環境狀態"
echo "══════════════════════════════════════════"
