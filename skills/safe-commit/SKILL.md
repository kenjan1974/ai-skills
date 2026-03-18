---
name: safe-commit
description: 安全地提交程式碼變更。執行品質檢查後再 commit。在需要 commit 時使用此 skill 而非直接 git commit。
---
 
# 安全提交流程
 
1. **檢查分支**：確認不在 main/master
2. **格式化**：`npx prettier --write --ignore-unknown $(git diff --cached --name-only) 2>/dev/null || true`
3. **Lint**：`npm run lint 2>&1 | head -20` （如果有設定）
4. **型別檢查**：`npx tsc --noEmit 2>&1 | head -20` （如果是 TS 專案）
5. **查看 staged 變更**：`git diff --cached --stat`
6. **產生 Conventional Commits message**：
   - 格式：`type(scope): 描述`
   - type：feat / fix / docs / chore / refactor / test
7. **commit**：`git add -A && git commit -m "{message}"`
8. **提醒**：是否需要更新 TODO.md？
