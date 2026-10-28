# EXPERIENCE — 2026-10-27-proxywar-sim-core-1b-1 (proxywar, 범위: 공통)

모드는 probe-less다. 과제 내용: proxywar 진행상황을 점검하고, 1b를 세 조각으로 나눈 뒤 1b-1(영웅 성장·특성·부상·포로·건물·점수) 계획을 세부 규칙 제안표와 함께 썼다. 그다음 subagent-driven-development로 구현·리뷰·커밋했다(`harness/runs/2026-10-27-proxywar-sim-core-1b-1/task.md` L3).
RUN 경로는 세션 폴더 `D:/game/proxywar` 기준이다(`harness/runs/`는 git에서 뺀다). 편집 번호는 `RUN/DECISION.md` 결정 표(L7~L10)를 따른다. 사용자 확정은 2026-10-27("권고대로")이다. 공통 범위는 1 채택, 2·3 보류이고, 범위 조정은 없다.
새 G 번호는 쓰지 않았다. 1은 기존 G-001의 적용 대상을 넓힌 것이다. 둘 다 사용자가 되물어야 결정할 수 있는 메시지를 막는 규칙이라 같은 줄에 둔다(`RUN/DECISION.md` L14).

## 적용 조건

- 편집 1(G-001 확장): 사용자에게 결정을 묻거나 남은 문제(리뷰 발견, 알려진 한계)를 알리는 모든 보고. 특히 리뷰가 찾은 규칙 빈칸을 사용자 결정으로 넘기거나, 결정 없이 "기록만" 해 둔 한계를 완료 보고에 적을 때다.
- 범위 근거: 리뷰 발견·한계를 사용자 결정으로 넘기는 보고 방식은 사용자와 확인하는 방식이다. 게임 설계와 무관하고 같은 문장으로 막힌다(README L15). 매 과제가 리뷰 발견·남은 문제를 보고하고 끝나므로 모든 과제에 해당한다. 한 세션에서 두 번(전사 L643, L1018) 났으므로 AGENTS.md 문장 확장 조건을 충족한다(`RUN/DECISION.md` L7).

## 관찰된 결함

### 편집 1 — 증상만 적고 문제의 본질·수치 예·대안을 빼 사용자가 되물음
- `RUN/reference/evidence.md` L7 (C4, 사용자 교정): 에이전트는 "30% 손실이 처리 순서에 따라 한 번 또는 두 번 납니다"라고 보고했다. 사용자는 "이거 문제야? 두 번 날 수 있는거 아니야?"라고 되물었다. 실제 문제는 같은 사건의 결과가 순서에 따라 갈린다는 것이었다. 금 25 대 35 시나리오로 다시 설명하자 사용자는 곧바로 "기록만 유지"를 골랐다.
- `RUN/reference/evidence.md` L32 (자기 보고): 증상("한 번 또는 두 번")만 적고, 문제의 본질과 수치 예를 바로 붙이지 않았다.
- 같은 세션의 앞선 관찰(Composer가 전사 `C:/Users/roehf/.claude/projects/D--game/14cc6483-2c60-4606-a026-30c9e429794e.jsonl`로 확인, `RUN/DECISION.md` L7): L643의 "확인이 필요한 규칙 2건"은 증상만 적었다. 순서 운(시드 10개 중 4개)과 대안이 빠져, 사용자가 L647에서 "바꾸고 싶음"을 누르고 한 번 더 왕복해야 했다.
- 문구를 넓힌 이유(`RUN/DECISION.md` L14): C4가 난 메시지(전사 L1018)는 결정을 묻지 않았다. 에이전트가 "기록만"을 이미 정하고 알려진 한계로 보고했다. 그래서 후보 문구의 "결정을 묻는 보고"만으로는 이 자리를 놓친다. 대상을 "결정을 묻거나 남은 문제(리뷰 발견, 알려진 한계)를 알리는 보고"로 넓혔다.
- 원 항목: hsl L-001 `D:/game/hsl/harness/library/2026-10-23-harness2-design/EXPERIENCE.md`(→ G-001). 같은 결함의 재관찰이 아니라 같은 규칙(사용자가 되물어야 완결되는 메시지)의 새 자리다. 다른 게임 LESSONS에는 같은 결함 행이 없다(`RUN/DECISION.md` L7). hsl 폴더는 고치지 않았다.

## 편집

`patch/`는 `RUN/composed/common/`을 그대로 복사했다(`diff -r` 결과 같음). 보류한 2·3은 composed에 없다.

- `patch/AGENTS.md` → `D:/game/AGENTS.md`: L31의 G-001 문장 끝에 한 문장을 붙였다. "결정을 묻거나 남은 문제(리뷰 발견, 알려진 한계)를 알리는 보고는 증상만 적지 않고, 무엇이 문제인지를 구체 예·수치로 보이며, 고를 대안과 각 결과를 같은 메시지에 둔다." 새 줄은 없고 주석 `<!-- G-001 -->`도 그대로다.

## 효과

미검증 · 사용자 채택 (probe-less라 네 축 비교 없음).
사용자가 세션 안에서 바로잡은 C4에 직접 대응한다. 상위 AGENTS.md가 자동 로드되므로 hsl·proxywar 모두 다음 세션부터 적용되고, 따로 연결할 것은 없다(`RUN/DECISION.md` L32·L33). 다음 과제에서 리뷰 발견·한계를 증상만으로 보고해 사용자가 되묻는 일이 생기면, 이 확장이 막지 못했다는 반증으로 기록한다.

## 상태

| 편집 | 교훈 ID | 상태 | 비고 |
|---|---|---|---|
| 1 | G-001 (기존 행 갱신) | 채택 | 공통 `LESSONS.md` G-001 행의 적용 조건·교훈·항목 열 갱신 |
| 2 | 없음 | 보류 (재관찰 대기, 세 번째) | 아래 참고. patch·색인 없음 |
| 3 | 없음 | 보류 (재관찰 대기, 세 번째) | 아래 참고. patch·색인 없음 |

### 보류 — 편집 2: 테스트 통과는 그 테스트가 결함을 잡을 때만 근거다 (G-006 확장 후보)
- 편집: `AGENTS.md`의 G-006 줄(L30) 끝에 한 문장을 붙인다. 계획 테스트와 회귀 테스트 모두, 대상 동작을 빼거나 틀리게 바꾸면 실패하는 입력인지 본다. 구현 전에 이미 통과하는 "실패 예정" 테스트는 신호로 본다. 기대값은 설계서에서 끌어낸다(`RUN/candidates/invariant/patch/common/AGENTS.md` L30).
- 근거: `RUN/reference/evidence.md` L21(단언이 동작을 검증하지 못하는 계획 테스트 5개를 리뷰 3번이 찾음), L26(Task 10 Step 2가 구현 전에도 통과), L31(자기 보고). 사용자 교정이 아니고 이번에도 리뷰가 막았다(`RUN/DECISION.md` L8·L15).
- 재관찰(세 번째, 두 게임): hsl `D:/game/hsl/harness/runs/2026-10-24-s1-combat-core/reference/evidence.md` L19·L29(hsl DECISION #3 보류), proxywar `D:/game/harness/library/proxywar/2026-10-27-proxywar-sim-core-1a/EXPERIENCE.md` 보류 편집 2. hsl 폴더는 고치지 않았다.
- 채택 시: invariant patch L30을 그대로 쓰고, 공통 `LESSONS.md` G-006 행의 적용 조건에 "테스트가 결함을 잡는지 판단할 때"를 더한다. 다음 과제를 probed로 돌리면 이 편집부터 시험하기를 권한다(`RUN/DECISION.md` L15).

### 보류 — 편집 3: 긴 본문은 Bash heredoc 대신 Write 후 `cat >>`
- 편집: "환경 메모"에 한 줄을 더한다(`RUN/candidates/invariant/patch/common/AGENTS.md` L37, 임시 주석 `<!-- G-009 -->`).
- 근거: `RUN/reference/evidence.md` L25(서브에이전트 2개가 heredoc 따옴표 오류로 첫 시도에 실패하고 Write로 다시 씀). 사용자 교정이 아니다. 비용은 재시도 1회이고 원인이 오류 메시지에 바로 보인다(`RUN/DECISION.md` L9·L16).
- 재관찰(세 번째, 두 게임): hsl `D:/game/hsl/harness/runs/2026-10-24-s1-combat-core/reference/evidence.md` L17·L24(hsl DECISION #5 보류), proxywar `D:/game/harness/library/proxywar/2026-10-27-proxywar-sim-core-1a/EXPERIENCE.md` 보류 편집 3. hsl 폴더는 고치지 않았다.
- 번호: 채택되면 그 시점 공통 색인의 다음 빈 번호를 쓴다(지금은 G-009). 번호를 점유하지 않았다.
- 재관찰: proxywar/2026-10-28-proxywar-sim-core-1b-2 (긴 heredoc이 `ENAMETOOLONG`으로 실패, 편집 미제안. `D:/game/proxywar/harness/runs/2026-10-28-proxywar-sim-core-1b-2/reference/evidence.md` L18)
- 재관찰: proxywar/2026-10-28-proxywar-sim-core-1b-3 (긴 python heredoc이 `unexpected EOF`로 실패, 다시 보류(네 번째). `D:/game/harness/library/proxywar/2026-10-28-proxywar-sim-core-1b-3/EXPERIENCE.md`)

### 게임 범위로 따로 기록한 것
편집 4(채택, L-004)는 `D:/game/proxywar/harness/library/2026-10-27-proxywar-sim-core-1b-1/EXPERIENCE.md`에 있다.
