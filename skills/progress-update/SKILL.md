---
name: progress-update
description: 更新專案進度。在完成任務、發現新的待辦事項、或需要記錄進度時使用。
---
 
# 專案進度更新
 
1. 讀取目前的 `TODO.md`
2. 根據使用者描述或本次 session 的工作成果，更新 TODO.md：
   - 完成的：移到「已完成」加日期 `- [x] YYYY-MM-DD 描述`
   - 進行中：標記 `@owner:current-agent`
   - 新發現的：加到「待處理」
3. commit：`git add TODO.md && git commit -m "docs: 更新專案進度"`
