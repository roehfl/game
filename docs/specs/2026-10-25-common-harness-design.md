# game 공통 하네스 설계 — 자기개선 루프와 두 범위(게임 / 공통)

- 날짜: 2026-10-25
- 상태: 구현 완료(레벨 1), 사용자 확인 전
- 범위: `D:/game`과 그 아래 게임 폴더들의 에이전트 하네스. 게임 설계·코드는 다루지 않는다.
- 참고: hsl 하네스(`D:/game/hsl`, 2026-10-25 `D:/hsl`에서 옮김, 설계 `D:/game/hsl/docs/superpowers/specs/2026-10-23-harness2-adoption-design.md`)

## 1. 목적

`D:/game` 아래에서 게임을 여럿 만든다. 게임마다 하네스(AGENTS.md·스킬·서브에이전트·스크립트·훅)가 있고, 모든 게임이 함께 쓰는 공통 하네스가 그 위에 있다.

hsl의 자기개선 루프(근거 수집 → Propose → Compose → 사용자 선택 → Reflect → 승인 뒤 반영)는 그대로 쓴다. 바뀌는 점은 하나다. **편집마다 적용 범위를 정해서**, 이 게임에만 해당하는 개선은 그 게임 하네스만 바꾸고, 모든 게임에 해당하는 개선은 공통 하네스를 바꾼다.

hsl에서 그대로 가져오는 원칙:

1. **대조 검증.** 편집은 "좋아 보여서"가 아니라 관찰된 결함(특히 사용자 교정)에 대응할 때만 채택한다.
2. **invariant / domain 분리.** 모든 과제에 해당하는 결함과 영역 지식을 다른 후보로 다룬다.
3. **새 과제는 기본 하네스에서 시작.** 교훈은 라이브러리에 쌓고, 승인된 편집만 기본 하네스에 들어간다.

여기에 원칙 하나를 더한다.

4. **범위 분리.** invariant/domain(편집의 종류)과 별개로 게임/공통(편집이 미치는 곳)을 정한다. 공통 하네스에는 게임이 바뀌어도 재발하는 결함에 대한 편집만 들어간다. 한 게임의 취향이 모든 게임의 규칙이 되는 것을 구조로 막는다.

## 2. 실측한 전제 (Claude Code 2.1.291, 2026-10-25)

`claude -p`로 부모·자식 폴더를 만들어 확인했다. 실측 폴더는 지웠다.

| 세션 폴더 | 부모 AGENTS.md | 부모 `.claude/skills`·`agents` | 부모 `settings.json` 훅 | 자식 AGENTS.md·스킬 |
|---|---|---|---|---|
| 자식(게임, git 저장소) | 로드됨 | **로드 안 됨** | **적용 안 됨** | 로드됨 |
| 부모(D:/game) | 로드됨 | 로드됨 | 적용됨 | 시작 시 로드 안 됨 |

추가로 확인한 것:

- `--add-dir ..`을 주면 부모 스킬·서브에이전트가 로드된다. 그러나 같은 일을 하는 `settings.json`의 `permissions.additionalDirectories`는 신뢰하지 않은 폴더에서 무시되고, 신뢰는 부모(D:/game, 신뢰됨)에서 이어지지 않는다(`D:/game/_hprobe`에서 무시됨). 이 방식은 쓰지 않는다.
- **디렉터리 정션**(`mklink /J`, 관리자 권한 불필요)은 신뢰 여부와 관계없이 동작한다.
  - 서브에이전트: `.claude/agents/_common` → 공통 `.claude/agents` 하나로 된다(하위 폴더도 찾는다).
  - 스킬: `.claude/skills/_common/<스킬>`처럼 한 단계 더 들어가면 찾지 않는다. 스킬마다 `.claude/skills/<스킬>` 정션이 필요하다.
  - git은 정션 안 파일을 일반 파일로 본다(`git add -n`이 추가하려 함). 제외가 필요하다.
  - Git Bash `rm -rf`, PowerShell 5.1 `Remove-Item -Recurse`로 정션이나 그 부모를 지워도 원본은 남는다.
- 게임 `settings.json`의 훅은 `bash "$CLAUDE_PROJECT_DIR/../tools/..."`처럼 상위 스크립트를 부를 수 있다.
- `PostToolUseFailure` 훅은 실패한 도구 호출(Bash `exit 3`, 없는 파일 Read)에서 `hook_event_name: "PostToolUseFailure"`로 호출된다. 이때 `tool_response`는 없고 `error`가 있다. hsl 훅이 실패를 0건 기록한 원인(hsl S1 근거 E12)이 이것이다. Windows Python 출력 끝의 `\r`도 비교를 깨므로 지운다.
- `settings.local.json`의 `env`(과제 ID)는 신뢰하지 않은 `-p` 세션에서도 적용됐다.

## 3. 구조

```
D:/game/                            공통 하네스. git 저장소(게임 폴더는 .gitignore로 제외)
  AGENTS.md                         공통 기본 하네스. 모든 게임 세션에 자동 로드
  .claude/settings.json             D:/game에서 연 세션용 도구 로그 훅
  .claude/skills/harness-reflect/   루프 진입점(두 범위)
  .claude/agents/harness-{proposer,composer,reflector}.md
  tools/harness-tool-log.sh         도구 로그 훅(모든 게임이 공유)
  tools/link-common.sh              공통 스킬·서브에이전트를 게임에 정션으로 연결
  tools/new-game.sh                 새 게임 폴더 생성
  templates/game/                   새 게임 하네스 틀
  harness/README.md                 루프와 범위 판정 기준
  harness/LESSONS.md                공통 교훈 색인(G-NNN)
  harness/library/<출처>/<과제 ID>/ 공통 범위로 채택된 편집
  harness/runs/<과제 ID>/           (git 제외) D:/game에서 한 과제의 실행 근거
  docs/specs/, docs/archive/reports/ 이 설계서와 HTML 보고서

D:/game/<게임>/                     게임 하네스. 게임마다 별도 git 저장소
  AGENTS.md                         게임 기본 하네스(게임 고유 규칙만)
  .claude/settings.json             훅 → ../tools/harness-tool-log.sh
  .claude/settings.local.json       (git 제외) env HARNESS_TASK
  .claude/skills/<게임 스킬>/       게임 고유
  .claude/skills/<공통 스킬>        정션 → D:/game/.claude/skills/<공통 스킬>
  .claude/agents/_common            정션 → D:/game/.claude/agents
  harness/LESSONS.md                게임 교훈 색인(L-NNN)
  harness/library/<과제 ID>/        게임 범위로 채택된 편집
  harness/runs/<과제 ID>/           (git 제외) 이 게임 과제의 실행 근거
```

- 게임 작업은 게임 폴더에서 세션을 연다. 그래야 두 AGENTS.md가 함께 로드되고 git이 게임 저장소를 가리킨다.
- 정션 경로는 게임 저장소의 `.git/info/exclude`에 `link-common.sh`가 적는다. 공통 스킬이 늘거나 줄어도 게임 저장소에 커밋할 변경이 생기지 않는다.
- 공통 스킬과 같은 이름의 게임 스킬은 만들지 않는다. 있으면 `link-common.sh`가 연결을 건너뛰고 경고한다.
- 기본 하네스는 공통 저장소와 게임 저장소의 git HEAD 상태다.

## 4. 범위 판정

판정 질문: **"다른 게임에서 같은 과제를 해도 같은 결함이 나고, 같은 편집으로 막히는가?"**

| 답 | 범위 | 결함이 있는 곳 | 예 |
|---|---|---|---|
| 예 | 공통 | 에이전트 습관, 사용자와의 확인 방식, 도구·환경(Windows·Claude Code·git), 하네스 루프 자체 | hsl L-001(질문 완결), L-005(외부 전제 확인), L-008(reflect 자동 진행) |
| 아니오 | 게임 | 이 게임의 설계 결정, 장르 감각, 수치, 코드 구조, 문서 배치 | hsl L-009~L-011(전투 체감) |
| 판단이 안 섬 | 게임 | — | 다른 게임에서 재관찰되면 승격 |

엔진·툴체인 지식(예: Godot C# API)은 그 엔진을 쓰는 게임이 하나면 게임 범위, 둘 이상이면 공통 스킬로 둔다.

범위와 종류는 따로 정한다. 네 칸은 이렇게 된다.

| 범위 \ 종류 | invariant | domain |
|---|---|---|
| 게임 | `<게임>/AGENTS.md`, `<게임>/.claude/settings.json` 훅 | `<게임>/.claude/skills·agents`, `<게임>/tools/` |
| 공통 | `AGENTS.md`, `tools/harness-tool-log.sh`, `templates/game/.claude/settings.json` | `.claude/skills·agents`, `tools/`, `templates/game/` |

### 4.1 승격과 강등

- **승격(게임 → 공통).** 같은 결함이 두 번째 게임에서 관찰되거나, 게임 범위로 둔 교훈이 게임과 무관하다는 근거가 생기면 승격한다. 편집은 "공통에 추가 + 이 게임의 같은 문장 삭제"를 한 쌍으로 낸다. 게임 LESSONS 행 상태는 `승격 → G-NNN`이 된다. 다른 게임에 남은 같은 문장은 그 게임의 다음 reflect에서 Proposer가 삭제 편집으로 낸다(L-003 성격). 한 세션이 다른 게임 폴더를 고치지 않게 하려는 것이다.
- **강등(공통 → 게임).** 공통 규칙이 어떤 게임에서 맞지 않는다는 것이 사용자 교정으로 드러나면, 공통에서 빼거나 조건을 좁히고 필요한 게임에만 둔다.

### 4.2 공통 편집에 더하는 장치

- Composer는 공통 범위 편집에 "채택 권고"를 줄 때 판정 질문의 답에 근거를 댄다. 근거가 없으면 "범위 조정 → 게임"이나 "보류"로 둔다.
- DECISION.md에 "영향 범위" 절을 둔다. 공통 편집이 닿는 게임 목록(`D:/game/*/AGENTS.md`가 있는 폴더)이다.
- 4단계에서 사용자는 결정과 범위를 함께 확정한다. 스킬과 서브에이전트는 범위를 넓히지 않는다. 게임에서 공통으로 바꾸는 것은 사용자만 할 수 있다.
- 6단계에서 반영 파일을 저장소별(게임 저장소 / 공통 저장소)로 나눠 보이고 승인받는다. 공통 스킬을 추가하거나 삭제했으면 `link-common.sh`로 모든 게임의 정션을 맞춘다.
- 게임 세션의 일반 작업 중에는 공통 하네스를 고치지 않는다. 공통 변경은 reflect 6단계 승인이나 사용자의 직접 요청으로만 한다.

## 5. 루프 (hsl과 같고, 범위만 더함)

| 단계 | 하는 일 | hsl과 다른 점 |
|---|---|---|
| 0 과제 정의 | `RUN = <세션 폴더>/harness/runs/<과제 ID>/`, `task.md` | 위치(게임 이름 또는 `_root`)를 적는다 |
| 1 근거 수집 | `reference/evidence.md`. 사용자 교정이 가장 강한 근거 | 없음 |
| 2 Propose | invariant·domain 후보 | 편집마다 범위. `patch/game/…`(게임 기준 경로), `patch/common/…`(D:/game 기준 경로). 다른 게임 LESSONS로 재관찰을 확인 |
| 3 Compose | 편집별 결정 | 범위 열, 범위 검증, 영향 범위 절 |
| 4 사용자 선택 | 결정 표를 그대로 보이고 확정받음 | 범위도 확정 |
| 5 Reflect | 라이브러리·LESSONS | 범위별로 다른 라이브러리와 색인(L-NNN / G-NNN) |
| 6 반영 | 승인 뒤 복사, 커밋 없음 | 저장소별 목록, 공통 스킬이 바뀌었으면 정션 갱신 |

라이브러리 출처: 공통 라이브러리 항목은 `harness/library/<출처>/<과제 ID>/`에 둔다. 출처는 과제를 한 게임 폴더 이름이고, `D:/game`에서 한 과제는 `_root`다.

교훈 ID: 공통은 `G-NNN`, 게임은 게임마다 `L-NNN`. AGENTS.md 주석도 같은 접두를 쓴다.

## 6. hsl에서 옮긴 것과 남긴 것

| hsl | 여기서 | 이유 |
|---|---|---|
| L-001, L-004, L-005, L-006 | 공통 AGENTS.md `G-001`, `G-004`~`G-006` | 판정 질문에 "예" — 과제·게임과 무관한 에이전트 습관 |
| L-002 | 공통 AGENTS.md `G-002` | 환경 사실. 상위 폴더 AGENTS.md 로드까지 다시 실측 |
| L-003 | `harness-proposer.md` `G-003` | 하네스 편집 규칙 |
| L-007 | 공통 AGENTS.md `G-007` | 세 과제 연속 교정. 문서 이름(brainstorm-log·ADR)만 "각 게임 AGENTS.md가 가리키는 확정 결정 기록"으로 일반화 |
| L-008 | `harness-reflect` 스킬 `G-008` | 루프 자체 |
| L-009~L-011 | 옮기지 않음 | 게임 범위(hsl 전투 체감) |
| 도구 로그 훅 | 공통 `tools/harness-tool-log.sh` | 실패 판정을 `PostToolUseFailure`로 교체. hsl S1에서 보류된 편집 #4와 같은 방향이고, 이번에 실제 세션으로 동작을 확인했다(§2) |
| `HSL_TASK` | `HARNESS_TASK` | 게임 이름에 묶이지 않게 |
| `chatgpt-connector-review`, Probe(레벨 2) | 옮기지 않음 | 루프 밖 도구, 미구현 |

hsl은 S2가 main에 머지된 뒤 `D:/hsl`에서 `D:/game/hsl`로 옮겼다(2026-10-25, 사용자 요청). 옮기면서 한 것:

- `link-common.sh hsl`로 공통 스킬·서브에이전트 정션 연결. 이름이 겹치는 hsl 자체 루프 파일(`harness-reflect` 스킬, `harness-*` 서브에이전트 셋, `tools/harness-tool-log.sh`)은 지웠다.
- 훅을 공통 틀의 `settings.json`(`../tools/harness-tool-log.sh`, `PostToolUseFailure` 포함)으로 바꾸고, 과제 변수 `HSL_TASK`를 `HARNESS_TASK`로 바꿨다.
- hsl AGENTS.md에서 공통과 겹치는 문장(L-001·L-002·L-004~L-007, git·언어 규칙)을 지웠다. hsl LESSONS의 L-001~L-008 상태는 `승격 → G-00N`. L-009~L-011과 `combat-feel`·`chatgpt-connector-review`는 게임 범위로 남겼다.
- Claude 메모리를 `D--hsl`에서 `D--game-hsl`로 복사했다. 옛 세션 전사는 `D--hsl`에 남아 있다. 옛 계획서의 `D:/hsl` 경로는 기록이라 고치지 않았다.
- 검증: `dotnet build -warnaserror` 경고 0, xUnit 261/261, 씬 테스트 21/21, 자동 진행 18방 `Cleared`. hsl 세션에서 공통·게임 AGENTS.md, 스킬 셋, 서브에이전트 셋이 중복 없이 로드된다.

## 7. 단계

| 레벨 | 하는 것 | 하지 않는 것 |
|---|---|---|
| 1(지금) | 두 범위 루프, 도구 로그 훅, 정션 연결, 새 게임 틀 | Probe |
| 2 | `--probe`: worktree에서 후보 하네스로 같은 과제를 다시 수행(hsl 설계 §5.3) | k>1, 자동 실행 |

## 8. 성공 기준

- 새 게임 폴더를 `new-game.sh`로 만들고 그 폴더에서 세션을 열면 공통·게임 AGENTS.md, `harness-reflect` 스킬, 하네스 서브에이전트 셋이 로드되고, `HARNESS_TASK`가 있으면 도구 로그가 성공·실패를 구분해 쌓인다.
- 게임 저장소의 `git status`에 정션 파일이 나오지 않고, 공통 저장소의 `git status`에 게임 폴더가 나오지 않는다.
- 첫 reflect에서 DECISION.md의 모든 편집에 범위와 그 근거가 있고, 채택된 편집이 범위에 맞는 라이브러리·색인에만 기록된다(미검증, 첫 과제 뒤 확인).

## 9. 알려진 한계

- 정션은 `D:/game` 안에서만 의미가 있다. 게임 저장소를 다른 곳에 클론하면 공통 스킬·서브에이전트·훅이 없다. 그 경우 공통 저장소를 같은 상대 위치(게임 폴더의 상위)에 두고 `link-common.sh`를 다시 돌린다.
- 공통 훅에 새 이벤트를 더하면 게임마다 `settings.json`을 고쳐야 한다(템플릿만으로는 기존 게임이 안 바뀐다). 반영 6단계에서 해당 게임 목록을 함께 보인다.
- 게임이 하나뿐인 동안에는 "다른 게임 재관찰" 근거가 생기지 않는다. 그 기간의 공통 편집은 판정 질문의 답(결함이 게임과 무관하다는 근거)에만 기댄다.
- `additionalDirectories` 방식은 폴더를 신뢰한 대화형 세션에서는 동작할 수도 있지만 확인하지 않았다(신뢰 설정은 보안 설정이라 시험용으로도 바꾸지 않음).
