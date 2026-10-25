#!/usr/bin/env bash
# 새 게임 폴더를 만든다: templates/game 복사 → git init(커밋 없음) → 공통 스킬·서브에이전트 정션 연결.
# 사용: bash tools/new-game.sh <게임 폴더 이름>   (영문 소문자·숫자·하이픈)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
name="${1:-}"

if ! [[ "$name" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "사용: bash tools/new-game.sh <게임 폴더 이름>  (영문 소문자·숫자·하이픈, 첫 글자는 영문 소문자나 숫자)"; exit 1
fi
case "$name" in docs|harness|templates|tools) echo "'$name'은 공통 하네스가 쓰는 이름이다."; exit 1;; esac
dest="$ROOT/$name"
[ -e "$dest" ] && { echo "이미 있다: $dest"; exit 1; }

cp -r "$ROOT/templates/game" "$dest"
sed -i "s/{{GAME}}/$name/g; s/{{DATE}}/$(date +%Y-%m-%d)/g" "$dest/AGENTS.md"
git -C "$dest" init -q
bash "$ROOT/tools/link-common.sh" "$name"
echo "만듦: $dest — 이 폴더에서 세션을 연다. 과제 도구 로그는 .claude/settings.local.json의 env HARNESS_TASK로 켠다."
