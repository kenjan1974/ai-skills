---
name: session-init
description: 開始新的工作 session 時自動執行。讀取專案狀態、待辦任務和交接紀錄，建立工作上下文。
---
 
# Session 初始化
 
每次開始工作時，依序執行以下步驟：
 
1. **讀取專案狀態**
   ```bash
   echo "=== 目前分支 ===" && git branch --show-current
   echo "=== 最近 5 筆 commit ===" && git log --oneline -5
   echo "=== 未 commit 的變更 ===" && git status --short
   ```
 
2. **讀取 TODO.md**，了解目前的任務進度
 
3. **讀取 HANDOFF.md**（如果存在），了解上一位代理的交接事項
 
4. **讀取 AGENTS.md**，確認專案規範和常用指令
 
5. **摘要報告**：用 3-5 句繁體中文向使用者報告目前狀態和建議的下一步行動
