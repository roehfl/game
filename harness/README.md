# harness/ — 하네스 개선 루프 (game 공통)

hsl 하네스(`D:/game/hsl`, Harness² arXiv 2610.14224 이식)의 자기개선 루프를 그대로 쓰고, 편집마다 적용 범위(게임 / 공통)를 정해 반영 위치를 나눈다. 설계: `docs/specs/2026-10-25-common-harness-design.md`.

## 루프

과제가 끝나면 `harness-reflect`: 근거 수집 → Propose(invariant·domain 후보) → Compose(편집별 결정·범위) → 사용자 선택 → Reflect(라이브러리) → 승인 뒤 반영. 과제 ID는 `YYYY-MM-DD-<slug>`.
기본 하네스는 공통 저장소(`D:/game`)와 게임 저장소의 git HEAD다. 새 과제는 항상 거기서 시작하고, 라이브러리는 Propose 단계에서만 참조한다.
도구 로그: 게임 `.claude/settings.local.json`의 `env`에 `"HARNESS_TASK": "<과제 ID>"`를 두면 `harness/runs/<과제 ID>/tool-log.jsonl`에 도구 호출과 실패가 쌓인다.

## 범위 판정

판정 질문: **"다른 게임에서 같은 과제를 해도 같은 결함이 나고, 같은 편집으로 막히는가?"**

- 예 → **공통**. 결함이 에이전트 습관, 사용자와의 확인 방식, 도구·환경(Windows·Claude Code·git), 하네스 루프 자체에 있다.
- 아니오 → **게임**. 결함이 이 게임의 설계 결정, 장르 감각, 수치, 코드 구조, 문서 배치에 있다(예: hsl L-009~L-011 전투 체감).
- 판단이 안 서면 → **게임**. 다른 게임에서 재관찰되면 공통으로 승격한다.
- 엔진·툴체인 지식은 그 엔진을 쓰는 게임이 하나면 게임, 둘 이상이면 공통 스킬.

**승격(게임→공통):** "공통에 추가 + 이 게임의 같은 문장 삭제"를 한 쌍으로 낸다. 게임 LESSONS 행 상태는 `승격 → G-NNN`. 다른 게임에 남은 같은 문장은 그 게임의 다음 reflect에서 지운다.
**강등(공통→게임):** 공통 규칙이 어떤 게임에 맞지 않는다는 것이 사용자 교정으로 드러나면, 공통에서 빼거나 조건을 좁히고 필요한 게임에만 둔다.
범위를 게임에서 공통으로 넓히는 확정은 사용자만 한다(4단계).

## 반영 위치

| 범위 | invariant 편집 | domain 편집 | 교훈 색인 | 라이브러리 |
|---|---|---|---|---|
| 게임 | `<게임>/AGENTS.md`, `<게임>/.claude/settings.json` 훅 | `<게임>/.claude/skills·agents`, `<게임>/tools/` | `<게임>/harness/LESSONS.md` (L-NNN) | `<게임>/harness/library/<과제 ID>/` |
| 공통 | `AGENTS.md`, `tools/harness-tool-log.sh`, `templates/game/.claude/settings.json` | `.claude/skills·agents`, `tools/`, `templates/game/` | `harness/LESSONS.md` (G-NNN) | `harness/library/<출처>/<과제 ID>/` |

- 출처: 과제를 한 게임 폴더 이름. `D:/game`에서 한 과제는 `_root`.
- 실행 근거 `harness/runs/<과제 ID>/`는 과제를 한 폴더(게임 또는 `D:/game`) 아래에 두고 git에서 뺀다. 승격되는 것은 EXPERIENCE.md·patch·LESSONS 한 줄뿐이다.
- 후보·결과의 patch 경로: `patch/game/<게임 기준 경로>`, `patch/common/<D:/game 기준 경로>`.
