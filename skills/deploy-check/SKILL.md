---
name: deploy-check
description: 部署前完整檢查。在推送到 staging 或 production 環境前使用。
---
 
# 部署前檢查
 
1. 確認分支：`git branch --show-current` 和與 main 的差異
2. 建構測試：`npm run build`
3. 完整測試：`npm test`
4. 環境變數：比對 `.env.example`
5. 資料庫遷移：`npx prisma migrate status`（如果使用 Prisma）
6. 文件確認：CHANGELOG 和 API 文件是否已更新
7. 產出部署清單摘要（繁體中文）
