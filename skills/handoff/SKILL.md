---
name: handoff
description: 產生代理交接紀錄。在 session 即將結束、額度即將用盡、或需要切換到另一個 AI 代理時使用。
---
 
# 代理交接紀錄產生器
 
## 執行步驟
 
1. **回顧本次 session** 中所有的檔案變更和操作
 
2. **檢查 git 狀態**：
   ```bash
   git status --short
   git log --oneline -5
   git diff --stat
   ```
 
3. **產生交接紀錄**，寫入 `HANDOFF.md`：
 
```
# 代理交接紀錄
## 交接資訊
- 時間：{YYYY-MM-DD HH:MM UTC+8}
- 代理：{Claude Code / Codex CLI / Gemini CLI}
- 分支：{目前 git 分支}
## 已完成工作
- [x] {完成項目}
## 進行中工作
- [ ] {進行中任務}
  - 檔案：{路徑}
  - 進度：{說明}
  - 注意：{下一位代理需知道的事}
## 待處理任務（依優先序）
1. {待辦}
## 關鍵決策紀錄
- {決策與原因}
```
 
4. **更新 TODO.md**：勾選完成項目，新增發現的待辦
 
5. **commit 所有變更**：
   ```bash
   git add -A
   git commit -m "wip: 代理交接前的進度保存"
   ```
 
6. **輸出摘要**（繁體中文）
