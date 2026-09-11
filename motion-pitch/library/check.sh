#!/usr/bin/env bash
# 配方库自检：索引与正文一致、每条配方带 reduced-motion 降级、无重复 id、列出未提交的库改动。
# 用法：bash motion-pitch/library/check.sh
set -u
cd "$(dirname "$0")" || exit 1
files=(entrance.md scroll.md hover.md feedback.md data.md transition.md ambient.md)
fail=0

idx_ids=$(grep -oE '^\| [a-z]{2}-[0-9]{2}' index.md | sed 's/| //' | sort)
body_ids=$(grep -hoE '^### [a-z]{2}-[0-9]{2}' "${files[@]}" | sed 's/### //' | sort)

echo "== 配方数：正文 $(echo "$body_ids" | grep -c .)，索引 $(echo "$idx_ids" | grep -c .)"
if ! diff <(echo "$idx_ids") <(echo "$body_ids") >/dev/null; then
  echo "!! 索引与正文不一致："; diff <(echo "$idx_ids") <(echo "$body_ids") | grep '^[<>]' | sed 's/^</  只在索引:/; s/^>/  只在正文:/'; fail=1
fi
dups=$(echo "$body_ids" | uniq -d)
[ -n "$dups" ] && { echo "!! 重复 id：$dups"; fail=1; }

for f in "${files[@]}"; do
  awk -v f="$f" '
    /^### / { if (id != "" && !rm) { print "!! " f " " id " 缺 prefers-reduced-motion 降级"; bad=1 } id=$2; rm=0 }
    /prefers-reduced-motion/ { rm=1 }
    END { if (id != "" && !rm) { print "!! " f " " id " 缺 prefers-reduced-motion 降级"; bad=1 } exit bad }
  ' "$f" || fail=1
done

echo "== 各分类："; for f in "${files[@]}"; do printf '  %-14s %s\n' "$f" "$(grep -c '^### ' "$f")"; done

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  changes=$(git status --short -- . | grep -v '^$')
  if [ -n "$changes" ]; then
    echo "== 库有未提交改动（review 后由你自己 commit）："; echo "$changes" | sed 's/^/  /'
    echo "== 未提交的新增配方："; git diff HEAD -- . 2>/dev/null | grep -E '^\+### [a-z]{2}-[0-9]{2}' | sed 's/^+/  /'
    for u in $(git ls-files --others --exclude-standard -- .); do grep -E '^### [a-z]{2}-[0-9]{2}' "$u" | sed "s/^/  [新文件 $u] /"; done
  else
    echo "== 库无未提交改动"
  fi
fi
[ $fail -eq 0 ] && echo "== 自检通过" || { echo "== 自检有问题，见上方 !! 行"; exit 1; }
