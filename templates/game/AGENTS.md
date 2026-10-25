# AGENTS.md — {{GAME}}

(게임 한 줄 설명 — 장르, 플랫폼, 목표. 첫 설계에서 채운다.)
공통 규칙은 상위 폴더의 `D:/game/AGENTS.md`(자동 로드)에 있다. 이 문서에는 이 게임에만 해당하는 것만 둔다.

## 지금 어디에 있나

{{DATE}} 게임 폴더 생성. 아직 설계 없음.

## 어디에 무엇이 있나

- 확정된 결정 기록 — (첫 설계 때 정한다. 예: `docs/design/brainstorm-log.md`, ADR `docs/decisions/`). 질문·설계 절의 전제는 여기 있는 것뿐이다(공통 G-007)
- `harness/` — 이 게임의 하네스 교훈 색인(`LESSONS.md`, L-NNN)과 라이브러리. 루프와 범위 판정 기준은 `D:/game/harness/README.md`
- `.claude/skills/`, `.claude/agents/` — 이 게임 전용. 공통 것은 정션(`.claude/skills/<공통 스킬>`, `.claude/agents/_common`)이라 git에 들어가지 않는다. 공통 스킬과 같은 이름의 게임 스킬은 만들지 않는다

## 하지 않는 것

- 승인된 설계·구현 계획 없이 게임 프로젝트·코드 파일을 만들기.

이 문서는 이 게임의 기본 하네스다. 모든 게임에 해당하는 규칙은 여기 두지 않고 공통 하네스로 보낸다(`harness-reflect` 범위 판정). 여기 추가되는 규칙은 출처 항목을 `<!-- L-NNN -->` 주석으로 단다.
