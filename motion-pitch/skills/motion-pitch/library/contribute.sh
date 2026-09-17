#!/usr/bin/env bash
# 把本地库里的一条配方贡献回上游仓库（GitHub Issue）。
# 用法：bash motion-pitch/skills/motion-pitch/library/contribute.sh <配方id>   例：bash motion-pitch/skills/motion-pitch/library/contribute.sh hv-12
# 有 gh 且已登录 → 直接建 issue；否则生成 outbox/<id>.md 并给出预填好的 New issue 链接，手动贴一下即可。
set -eu
cd "$(dirname "$0")"
id="${1:-}"; [ -z "$id" ] && { echo "用法：contribute.sh <配方id>"; exit 1; }
upstream=$(cat UPSTREAM)
row=$(grep -E "^\| $id \|" index.md || true)
[ -z "$row" ] && { echo "索引里没有 $id，先入库再贡献"; exit 1; }
file=$(echo "$row" | awk -F'|' '{gsub(/ /,"",$9); print $9}')
name=$(echo "$row" | awk -F'|' '{gsub(/^ +| +$/,"",$3); print $3}')
section=$(awk -v id="$id" '$0 ~ "^### "id"  " {on=1} on && /^### / && $0 !~ "^### "id"  " {exit} on {print}' "$file")
[ -z "$section" ] && { echo "$file 里没找到 ### $id"; exit 1; }
mkdir -p outbox
body="outbox/$id.md"
{
  echo "## 配方贡献：$id $name"
  echo
  echo "- 目标文件：\`library/$file\`"
  echo "- 索引行："
  echo
  echo '```'
  echo "$row"
  echo '```'
  echo
  echo "- 来自：motion-pitch 下游使用，已在本地预览跑通"
  echo
  echo "### 配方正文（追加到 $file 末尾）"
  echo
  echo "$section"
} > "$body"
title="recipe: $id $name"
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  url=$(gh issue create --repo "$upstream" --title "$title" --body-file "$body" 2>&1 | tail -1)
  echo "已提交上游 issue：$url"
else
  t_enc=$(printf '%s' "$title" | python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read()))')
  b_enc=$(python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read()))' < "$body")
  link="https://github.com/${upstream}/issues/new?title=${t_enc}&body=${b_enc}"
  echo "本机没有 gh（或未登录）。配方已写到 library/${body}，打开下面链接会预填标题和正文，确认提交即可："
  echo "$link"
fi
