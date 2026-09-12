# mlgb7checkin

[image.mlgb7.com](https://image.mlgb7.com) 每日自动签到（GitHub Actions 定时任务）。

## 原理

每天定时向 `https://image.mlgb7.com/api/me/checkin` 发送一个空的 POST 请求，
携带 Cookie 中的 `chatgpt2api_session` 即完成签到。

## 配置 Secret（必须）

在仓库 **Settings → Secrets and variables → Actions → New repository secret** 添加：

| Name | Secret |
|---|---|
| `CHATGPT2API_SESSION` | 你的 session 值 |

session 值获取方式：登录后按 F12 → Network → 找到 `checkin` 请求 → 请求头 cookie 里
`chatgpt2api_session=` 后面那串。

## 运行时间

- workflow 的 cron 使用 **UTC**：`0 1 * * *` = 北京时间每天 **09:00**
- GitHub 定时任务通常有几分钟到几十分钟延迟，属正常现象
- 定时任务只在**默认分支**上生效

## 手动签到

- Actions → Checkin → Run workflow
- 或本地运行：`CHATGPT2API_SESSION=xxx bash checkin.sh`

## 注意

- session 过期后签到会失败（HTTP 401/403），需重新抓取并更新 Secret
- 仓库 **60 天无任何活动**时 GitHub 会自动停用定时任务，偶尔手动 Run 一次即可
