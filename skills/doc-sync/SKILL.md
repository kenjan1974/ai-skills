---
name: doc-sync
description: 同步更新專案文件。在修改了 API、資料庫 schema、專案結構後使用。確保 README 和 API 文件與程式碼一致。
---
 
# 文件同步檢查與更新
 
1. 分析最近變更：`git diff --name-only HEAD~3..HEAD`
2. 判斷需更新的文件：
   - controller/route 變更 → API 文件
   - schema 變更 → 資料庫文件/ERD
   - 目錄結構變更 → README
   - package.json scripts 變更 → README 常用指令
   - 重大功能 → CHANGELOG.md
3. 逐一更新過時的段落
4. 更新 AGENTS.md（如果技術棧或指令有變）
5. commit：`git add README.md CHANGELOG.md docs/ AGENTS.md && git commit -m "docs: 同步更新專案文件"`
6. 繁體中文撰寫
