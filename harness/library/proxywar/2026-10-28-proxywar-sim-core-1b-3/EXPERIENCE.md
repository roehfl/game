# EXPERIENCE — 2026-10-28-proxywar-sim-core-1b-3 (proxywar, 범위: 공통)

모드는 probe-less다. 과제 내용: 1b-3(외교 6종) 계획을 제안표와 함께 썼고, 스크래치 복제본에서 Task 코드를 구현·실행하며 계획을 완성했다. 그 뒤 main에서 구현하고 커밋·푸시했다(`harness/runs/2026-10-28-proxywar-sim-core-1b-3/task.md` L3).
RUN 경로는 세션 폴더 `D:/game/proxywar` 기준이다(`harness/runs/`는 git에서 뺀다). 편집 번호는 `RUN/DECISION.md` 결정 표(L7~L8)를 따른다. 사용자 확정은 2026-10-28이다. 공통 범위는 1 보류이고, 범위 조정은 없다. 게임 범위 편집 2(보류)는 `D:/game/proxywar/harness/library/2026-10-28-proxywar-sim-core-1b-3/EXPERIENCE.md`에 있다.
이 항목은 보류 기록이다. 채택된 공통 편집이 없어 `patch/`와 공통 색인 행을 두지 않았다. G 번호도 점유하지 않았다(공통 `LESSONS.md`는 G-008까지).

## 적용 조건

- 편집 1(G-009 후보): Bash 도구로 긴 본문(HTML 보고서, 계획 덧붙이기, python 같은 스크립트 본문)을 쓰거나 실행할 때. 모든 과제에 해당한다(`RUN/DECISION.md` L12).
- 범위 근거: 결함은 Bash 도구와 Windows 셸의 명령 길이·따옴표 한계에 있어 게임과 무관하고, 같은 줄로 막힌다(README L15 도구·환경, `RUN/DECISION.md` L7 범위 근거 열).

## 관찰된 결함

### 편집 1 — 긴 본문을 Bash heredoc·인라인 인자에 실어 첫 시도가 실패함
- `RUN/reference/evidence.md` L23: 긴 python heredoc을 Bash 한 명령에 넣었다가 `unexpected EOF while looking for matching`으로 실패했다. 패치 명세를 스크래치 파일로 쓰고 도우미 스크립트로 적용하는 방식으로 바꿔 풀었다. 1b-2의 ENAMETOOLONG과 같은 계열이다.
- 사용자 교정이 아니다(`RUN/reference/evidence.md` L3 C0, 사용자 답 "선택 없음"). 비용은 재시도 1회였고 원인은 오류 메시지로 바로 보였다(`RUN/DECISION.md` L7).
- 재관찰 이력(두 게임, 다섯 과제). 앞의 세 과제에서는 같은 편집이 보류됐다.
  - hsl `D:/game/hsl/harness/runs/2026-10-24-s1-combat-core/reference/evidence.md` L17(E12, 서브에이전트 heredoc 파싱 실패와 긴 heredoc ENAMETOOLONG)·L24(E19, 계획 덧붙이기 heredoc ENAMETOOLONG). 그때 hsl `DECISION.md` #5로 보류됐다. hsl 폴더는 고치지 않았다.
  - proxywar 1a: `D:/game/harness/library/proxywar/2026-10-27-proxywar-sim-core-1a/EXPERIENCE.md` 보류 편집 3(1a DECISION #3)
  - proxywar 1b-1: `D:/game/harness/library/proxywar/2026-10-27-proxywar-sim-core-1b-1/EXPERIENCE.md` 보류 편집 3(1b-1 DECISION #3). 그 항목 끝에 1b-2·1b-3 재관찰 줄을 더했다.
  - proxywar 1b-2: `D:/game/proxywar/harness/runs/2026-10-28-proxywar-sim-core-1b-2/reference/evidence.md` L18(긴 heredoc → `ENAMETOOLONG`, 스크래치 파일 5개로 나눠 이어 붙임). 편집은 제안되지 않았다.
  - 이번 1b-3: `RUN/reference/evidence.md` L23
- 보류 사유가 바뀌었다(`RUN/DECISION.md` L7, L12). 이전 보류 사유 가운데 "재발 근거가 모자란다"는 이제 맞지 않는다. 슬라이스마다 빠짐없이 나왔으므로 AGENTS.md를 늘리는 조건(그 범위의 모든 과제에서 재발)은 충족한다. 이번에 막은 것은 probe-less 모드 기준 하나다. 사용자가 바로잡은 지점에 대응하지 않는다.

## 편집

채택된 편집이 없어 `patch/`는 두지 않았다. 보류 편집의 원본은 RUN에 남아 있다.

- 편집 1: `RUN/candidates/invariant/patch/common/AGENTS.md` L39. "환경 메모" 끝에 한 줄을 더한다. 긴 본문(HTML 보고서, 계획 덧붙이기, python 같은 스크립트 본문)은 Bash heredoc·인라인 인자에 싣지 않는다. Write로 스크래치 파일에 쓴 뒤 실행하거나 `cat >>`로 붙인다. 임시 주석은 `<!-- G-009 -->`다. 기준은 공통 작업 트리의 AGENTS.md이므로, 1b-2에서 승인된 미커밋 G-004 확장을 되돌리지 않는다. 1b-1 보류 문구와 견주면 "서브에이전트가 쓰는 파일"을 "python 같은 스크립트 본문"으로 바꾸었고 "인라인 인자"(ENAMETOOLONG 경로)를 더했다(`RUN/candidates/invariant/RATIONALE.md` L3).

## 효과

해당 없음 (보류, probe-less).

## 상태

| 편집 | 교훈 ID | 상태 | 비고 |
|---|---|---|---|
| 1 | 없음 (G-009 후보) | 보류 (네 번째) | 아래 참고. patch·색인 없음 |

### 보류 — 편집 1을 채택할 때
- 후보 patch를 `D:/game/AGENTS.md`에 그대로 반영한다. 상위 AGENTS.md는 자동 로드되므로 hsl·proxywar에 따로 연결할 것은 없다. `link-common.sh`와 게임 `settings.json`은 고치지 않아도 된다(`RUN/DECISION.md` L23).
- 번호: 채택되면 그 시점 공통 색인의 다음 빈 번호를 쓴다(지금은 G-009). 번호를 점유하지 않았다. 색인 행의 적용 조건은 "Bash 도구로 긴 본문(보고서·계획·스크립트)을 쓰거나 실행할 때 — 모든 과제"로 하고, 항목 열에는 hsl s1-combat-core와 proxywar 1a·1b-1·1b-2·1b-3을 적는다(`RUN/DECISION.md` L12).
- 다섯 번째 보류를 피하려면 4단계에서 사용자가 정하거나, 다음 과제를 probed로 돌려 이 편집부터 시험해야 한다(`RUN/DECISION.md` L12).
