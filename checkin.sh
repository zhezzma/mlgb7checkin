#!/usr/bin/env bash
# image.mlgb7.com 每日签到
# 用法: CHATGPT2API_SESSION=<session值> bash checkin.sh
set -euo pipefail

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
  -H "cookie: chatgpt2api_session=${CHATGPT2API_SESSION}")

body="$(cat "$resp_file")"
echo "HTTP $http_code"
echo "$body"

if [ "$http_code" = "200" ] && grep -q 'checked_in_today' "$resp_file"; then
  echo '✅ 签到成功（或今天已签过）'
  exit 0
fi

echo '❌ 签到失败'
exit 1
