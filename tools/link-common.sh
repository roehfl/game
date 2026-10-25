#!/usr/bin/env bash
# 공통 스킬·서브에이전트를 게임 폴더에 디렉터리 정션으로 연결한다.
# 게임 세션은 상위 폴더의 .claude를 로드하지 않으므로(2026-10-25 실측) 이 연결이 있어야 공통 스킬·서브에이전트가 보인다.
#   <게임>/.claude/agents/_common      → D:/game/.claude/agents      (서브에이전트는 하위 폴더도 찾는다)
#   <게임>/.claude/skills/<공통 스킬>  → D:/game/.claude/skills/<스킬> (스킬은 한 단계만 찾으므로 하나씩)
# 공통에서 없어진 스킬의 정션은 지운다. 정션 경로는 게임 저장소의 .git/info/exclude에 적어 커밋되지 않게 한다.
# 사용: bash tools/link-common.sh [게임 폴더 이름...]   인자가 없으면 모든 게임(AGENTS.md와 harness/LESSONS.md가 있는 하위 폴더).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

mkjunction() { cmd //c "mklink /J $(cygpath -w "$1") $(cygpath -w "$2")" >/dev/null; }
rmjunction() { cmd //c "rmdir $(cygpath -w "$1")"; }   # 정션만 지운다. 원본은 남는다.

games=("$@")
if [ ${#games[@]} -eq 0 ]; then
  for d in "$ROOT"/*/; do
    d=${d%/}
    [ -f "$d/AGENTS.md" ] && [ -f "$d/harness/LESSONS.md" ] && games+=("$(basename "$d")")
  done
fi
[ ${#games[@]} -eq 0 ] && { echo "연결할 게임 폴더가 없다."; exit 0; }

for g in "${games[@]}"; do
  gd="$ROOT/$g"
  if [ ! -f "$gd/AGENTS.md" ] || [ ! -f "$gd/harness/LESSONS.md" ]; then
    echo "건너뜀: $g (AGENTS.md·harness/LESSONS.md가 있는 게임 폴더가 아니다)"; continue
  fi
  mkdir -p "$gd/.claude/skills" "$gd/.claude/agents"
  entries=("/.claude/agents/_common/")

  if [ -L "$gd/.claude/agents/_common" ]; then :
  elif [ -e "$gd/.claude/agents/_common" ]; then echo "경고: $g/.claude/agents/_common이 정션이 아니라 연결하지 않았다"
  else mkjunction "$gd/.claude/agents/_common" "$ROOT/.claude/agents"; fi

  for s in "$gd"/.claude/skills/*; do
    [ -L "$s" ] || continue
    n=$(basename "$s")
    [ -d "$ROOT/.claude/skills/$n" ] || { rmjunction "$s"; echo "정션 제거: $g/.claude/skills/$n"; }
  done

  linked=0
  for s in "$ROOT"/.claude/skills/*; do
    [ -d "$s" ] || continue
    n=$(basename "$s"); t="$gd/.claude/skills/$n"
    if [ -L "$t" ]; then :
    elif [ -e "$t" ]; then echo "경고: $g에 공통 스킬과 같은 이름의 게임 스킬 '$n'이 있어 연결하지 않았다"; continue
    else mkjunction "$t" "$s"; fi
    entries+=("/.claude/skills/$n/"); linked=$((linked + 1))
  done

  if [ -d "$gd/.git" ]; then
    ex="$gd/.git/info/exclude"; mkdir -p "$gd/.git/info"; touch "$ex"
    sed -i '/^# >>> link-common/,/^# <<< link-common/d' "$ex"
    { echo "# >>> link-common (D:/game/tools/link-common.sh가 관리한다)"; printf '%s\n' "${entries[@]}"; echo "# <<< link-common"; } >> "$ex"
  else
    echo "경고: $g는 git 저장소가 아니라 정션 제외를 적지 못했다. git init 뒤 다시 실행한다."
  fi
  echo "연결: $g — 공통 스킬 ${linked}개, 서브에이전트 .claude/agents/_common"
done
