# EXPERIENCE — 2026-10-27-proxywar-sim-core-1a (proxywar, 범위: 공통)

모드: probe-less. 과제: brainstorming으로 기술 설계를 하위 프로젝트로 나눠 시뮬레이션 코어 설계서를 승인받고, 1a 뼈대 계획을 쓴 뒤 subagent-driven-development로 1a를 구현·리뷰·커밋한 과제(`harness/runs/2026-10-27-proxywar-sim-core-1a/task.md` L3).
RUN 경로는 세션 폴더 `D:/game/proxywar` 기준(`harness/runs/`는 git에서 뺀다). 편집 번호는 `RUN/DECISION.md` 결정 표(L7~L12)를 따른다. 사용자 확정 2026-10-27("권고대로"): 공통 범위는 1 채택, 2·3 보류. 범위 조정 없음.
새 G 번호는 쓰지 않았다. 1은 기존 G-007의 재관찰과 문장 확장이다.

## 적용 조건

- 편집 1(G-007 확장): 브레인스토밍·설계에서 질문 선택지를 내거나 **추천**을 하는 모든 과제, 특히 다른 게임의 선례(언어·구조)를 근거로 삼고 싶거나, 추천을 좌우하는 상위 요구(대상 플랫폼, 서비스 범위, 결과물을 다시 쓸 곳)가 확정 기록에 없을 때.
- 범위 근거: 기록에 없는 전제(다른 게임의 선례, 묻지 않은 상위 요구)로 추천하는 것은 에이전트 습관이고 게임 설계와 무관하다. hsl L-007(→ G-007), proxywar 킥오프 확장에 이어 세 과제째 같은 결함이 문구 밖 자리에서 사용자 교정으로 나왔다. 모든 설계·브레인스토밍 과제가 추천을 내므로 AGENTS.md 문장 확장 조건을 충족한다(`RUN/DECISION.md` L7).

## 관찰된 결함

### 편집 1 — 상위 요구를 묻지 않고 선례·개인 판단으로 추천함 (G-007 재관찰)
- `RUN/reference/evidence.md` L4 (C1, 사용자 교정): 코어 언어 질문에서 hsl 선례(C# Core + xUnit)를 근거로 C#을 추천했다. 클라이언트 플랫폼은 확정 기록에 없었는데 묻지 않았다. 사용자: "클라이언트 도트로 안할거면 노드가 낫나? 클라이언트는 다양해야해 pc, 모바일 등등" → TypeScript로 바뀌었다.
- `RUN/reference/evidence.md` L5 (C2, 사용자 교정): 프롬프트 언어 질문에서 "입력 영어, 일지 한국어"를 추천했다. 사용자: "월드서버 열거면 모두 영어가 맞지않나?" → 월드 서버 확정, 모두 영어로 바뀌었다.
- `RUN/reference/evidence.md` L6 (C3, 판단 기준 보충 요청 — 약한 근거): 코어 구조 장단점이 재사용 대상(서버·클라이언트·리플레이·분석) 기준으로 짜여 있지 않아 사용자가 "나중에 재활용할걸 염두에 두면 뭐가 낫지?"로 되물었다. 같은 원인이라 예시 "결과물을 다시 쓸 곳"으로만 들어갔고, 빼도 결정은 같다(`RUN/DECISION.md` L16).
- `RUN/reference/evidence.md` L32 (자기 보고): 추천 전에 상위 요구가 확정 기록에 있는지 보지 않고 선례(hsl)와 개인 판단으로 채웠다.
- 원인(`RUN/DECISION.md` L7·L16): 현행 G-007 문구는 "질문 선택지와 설계 절", "상위 설계서 문구·에이전트가 먼저 정한 구조·수치"만 들어, 추천과 다른 게임의 선례가 문구 밖이었다. 킥오프처럼 문구가 닿는 자리에서는 지켰고 문구 밖에서만 놓쳤다.
- 바로잡힌 두 사실은 `D:/game/proxywar/AGENTS.md` L3("월드 서버, 클라이언트는 PC·모바일 등 다중 플랫폼")과 결정 기록에 들어가 있다.
- 원 항목: hsl L-007 `D:/game/hsl/harness/library/2026-10-24-s1-combat-core/EXPERIENCE.md` (`D:/game/hsl/harness/LESSONS.md` L14, 승격 → G-007). 이전 확장: `D:/game/harness/library/proxywar/2026-10-27-proxywar-kickoff/EXPERIENCE.md`.
- 재관찰: proxywar/2026-10-27-proxywar-sim-core-1a

## 편집

`patch/`는 `RUN/composed/common/`을 그대로 복사했다(`diff -r` 같음). 보류한 2·3은 composed에 없다.

- `patch/AGENTS.md` → `D:/game/AGENTS.md`: L22 G-007 문장만 바꿈. 적용 대상을 "질문 선택지·추천과 설계 절"로, 확정이 아닌 것에 "다른 게임의 선례"를 더하고, 끝에 "추천을 좌우하는 상위 요구(대상 플랫폼, 서비스 범위, 결과물을 다시 쓸 곳 같은)가 기록에 없으면 추천보다 그것을 먼저 묻는다"를 붙임. 대시 삽입구 "사용자가 그 선택지를 골랐어도 미정"은 괄호 안으로 옮김(뜻 같음, G-003). 새 줄 없음, 주석 `<!-- G-007 -->` 그대로.

## 효과

미검증 · 사용자 채택 (probe-less, 네 축 비교 없음).
사용자가 세션 안에서 바로잡은 C1·C2에 직접 대응한다. 상위 AGENTS.md 자동 로드로 hsl·proxywar 다음 세션부터 적용되고, 연결할 것은 없다(`RUN/DECISION.md` L35·L36). 다음 설계에서 기록에 없는 상위 요구를 묻지 않고 추천하거나 다른 게임 선례를 근거로 추천하면 이 확장이 막지 못했다는 반증으로 기록한다.

## 상태

| 편집 | 교훈 ID | 상태 | 비고 |
|---|---|---|---|
| 1 | G-007 (기존 행 갱신) | 채택 | 공통 `LESSONS.md` G-007 행의 적용 조건·교훈·항목 열 갱신 |
| 2 | 없음 | 보류 (재관찰 대기) | 아래 참고. patch·색인 없음 |
| 3 | 없음 | 보류 (재관찰 대기) | 아래 참고. patch·색인 없음 |

### 보류 — 편집 2: 테스트 통과는 그 테스트가 결함을 잡을 때만 근거다 (G-006 확장 후보)
- 편집: `AGENTS.md` G-006 줄(L30) 끝에 "테스트 통과는 그 테스트가 결함을 잡을 때만 근거다 — 기대값은 설계서에서, 버그 회귀 테스트는 수정을 빼고 돌려 실패하는지 본다"를 붙임(`RUN/candidates/invariant/patch/common/AGENTS.md` L30).
- 근거: `RUN/reference/evidence.md` L23(전투 버그 회귀 테스트를 시드 하나로 써 버그가 드러나지 않음, 수정을 빼고 돌려서야 앎), L20(계획에 직접 쓴 전투 코드의 Critical 버그를 리뷰 탐침이 찾음), L34(자기 보고). 사용자 교정이 아니고 두 번 모두 리뷰가 막았다(`RUN/DECISION.md` L8·L17).
- 다른 게임 재관찰: hsl `D:/game/hsl/harness/runs/2026-10-24-s1-combat-core/reference/evidence.md` L19·L29(E14·E23, 자기 구현에서 끌어낸 기대값이 판정 1틱 지연을 고정), 그때 hsl `DECISION.md` #3으로 보류. 이번이 두 게임째다. hsl 폴더는 고치지 않았다.
- 채택 시: invariant patch L30을 `D:/game/AGENTS.md` L30 자리에 넣고, 내용이 "검증 출력 읽기"와 "테스트가 결함을 잡는지" 둘이 되므로 공통 `LESSONS.md` G-006 행의 적용 조건도 넓힌다(`RUN/DECISION.md` L17).

### 보류 — 편집 3: 긴 본문은 Bash heredoc 대신 Write 후 `cat >>`
- 편집: "환경 메모"에 한 줄 추가(`RUN/candidates/invariant/patch/common/AGENTS.md` L38, 임시 주석 `<!-- G-009 -->`).
- 근거: `RUN/reference/evidence.md` L25(heredoc → `unexpected EOF while looking for matching '`, Write 후 cat으로 해결). 사용자 교정이 아니고 비용은 재시도 1회, 원인이 오류 메시지에 바로 보인다(`RUN/DECISION.md` L9·L18).
- 다른 게임 재관찰: hsl `D:/game/hsl/harness/runs/2026-10-24-s1-combat-core/reference/evidence.md` L24(E19 `ENAMETOOLONG`)·L17(E12), 그때 hsl `DECISION.md` #5로 보류. hsl 폴더는 고치지 않았다.
- 번호: 채택되면 그 시점 공통 색인의 다음 빈 번호(지금은 G-009). 번호는 점유하지 않았다. 채택 시 후보 문장의 경위 서술("…오류가 났다")은 빼는 편이 원칙 중심 문서에 맞다(`RUN/DECISION.md` L18).

### 게임 범위로 따로 기록한 것
편집 4(채택, L-003)와 5·6(보류)은 `D:/game/proxywar/harness/library/2026-10-27-proxywar-sim-core-1a/EXPERIENCE.md`에 있다.
