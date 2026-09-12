#!/usr/bin/env bash
# image.mlgb7.com 每日签到
# 用法: CHATGPT2API_SESSION=<session值> bash checkin.sh
# 结果写入 checkin.log（每次覆盖，历史由 git 提交记录保存）
set -uo pipefail

: "${CHATGPT2API_SESSION:?请设置环境变量 CHATGPT2API_SESSION}"

url='https://image.mlgb7.com/api/me/checkin'
resp_file="$(mktemp)"
trap 'rm -f "$resp_file"' EXIT

http_code=$(curl -sS --max-time 30 -o "$resp_file" -w '%{http_code}' -X POST --data '' \
  "$url" \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'accept-language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'origin: https://image.mlgb7.com' \
  -H 'referer: https://image.mlgb7.com/account' \
  -H 'sec-ch-ua: "Chromium";v="152", "Not?A_Brand";v="24", "Microsoft Edge";v="152"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'priority: u=1, i' \
  -H "cookie: chatgpt2api_session=${CHATGPT2API_SESSION}") || http_code=000

body="$(cat "$resp_file" 2>/dev/null)"

printf '%s | HTTP %s | %s\n' "$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M')" "$http_code" "$body" > checkin.log

echo "HTTP $http_code"
echo "$body"

if [ "$http_code" = "200" ] && printf '%s' "$body" | grep -q 'checked_in_today'; then
  echo '✅ 签到成功（或今天已签过）'
  exit 0
fi

echo '❌ 签到失败'
exit 1
