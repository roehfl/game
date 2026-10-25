#!/usr/bin/env bash
# PostToolUse·PostToolUseFailure 훅. HARNESS_TASK가 설정된 세션에서만
# $CLAUDE_PROJECT_DIR/harness/runs/$HARNESS_TASK/tool-log.jsonl에 한 줄 추가한다.
# 게임 세션이면 게임 폴더, D:/game에서 연 세션이면 공통 하네스 아래에 쌓인다.
# 실패 여부는 훅 이벤트 이름으로 판정한다(PostToolUse의 tool_response 휴리스틱은 hsl에서 실패를 0건 잡았다).
# stdin: Claude Code 훅 JSON. 인자·출력은 기록하지 않는다.
[ -z "${HARNESS_TASK:-}" ] && exit 0
[ -z "${CLAUDE_PROJECT_DIR:-}" ] && exit 0
case "$HARNESS_TASK" in *..*|*/*|*'\'*) exit 0;; esac
PY=$(command -v python 2>/dev/null || command -v python3 2>/dev/null || command -v py 2>/dev/null)
[ -z "$PY" ] && exit 0
read -r tool event < <("$PY" -c 'import sys,json; d=json.load(sys.stdin); print(d.get("tool_name") or "-", d.get("hook_event_name") or "-")' 2>/dev/null | tr -d '\r')
[ -z "$tool" ] || [ "$tool" = "-" ] && exit 0
err=""; [ "$event" = "PostToolUseFailure" ] && err="true"
dir="$CLAUDE_PROJECT_DIR/harness/runs/$HARNESS_TASK"
mkdir -p "$dir"
printf '{"ts":"%s","tool":"%s","error":"%s"}\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$tool" "$err" >> "$dir/tool-log.jsonl"
exit 0
