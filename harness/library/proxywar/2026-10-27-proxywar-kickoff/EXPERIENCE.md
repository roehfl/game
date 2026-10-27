# EXPERIENCE — 2026-10-27-proxywar-kickoff (proxywar, 범위: 공통)

모드: probe-less. 과제: 새 게임 아이디어를 듣고 `tools/new-game.sh`로 `proxywar`를 만든 뒤 brainstorming으로 첫 게임 규칙 설계서·HTML 보고서·초기 커밋까지 한 과제(`harness/runs/2026-10-27-proxywar-kickoff/task.md` L3).
RUN 경로는 세션 폴더 `D:/game/proxywar` 기준(`harness/runs/`는 git에서 뺀다). 편집 번호는 `RUN/DECISION.md` 결정 표(L7~L12)를 따른다. 사용자 확정 2026-10-27: 1·3·4·5 공통 채택, 2·6 보류, 범위 조정 없음.
새 G 번호는 쓰지 않았다. 1·3은 기존 G-007·G-005의 재관찰과 문장 확장, 4는 사실 갱신, 5는 도구 수정이다.

## 적용 조건

- 편집 1(G-007 확장): 브레인스토밍 질문 선택지·설계서 절을 쓰는 모든 과제, 특히 선택지 설명에 예시 수치를 넣을 때. 범위 근거: 선택지 예시를 결정으로 취급하는 것은 에이전트 습관이고 게임 설계와 무관하다. hsl L-007(→ G-007)에 이어 다른 게임에서 다시 나왔다.
- 편집 3(G-005 확장): 계획·설계서뿐 아니라 다음 단계 제안이 외부 서비스(이용 수단·비용)를 전제로 삼을 때. 범위 근거: 외부 전제를 확인 없이 단정하는 습관은 게임 콘텐츠와 무관하다. hsl L-005(→ G-005)와 같은 결함이 다른 자리에서 나왔다.
- 편집 4(등록된 게임 목록): 교훈 아님. 공통 AGENTS.md 안의 사실 문장이라 공통 말고 반영할 곳이 없다.
- 편집 5(`new-game.sh` 기본 브랜치): `tools/new-game.sh`로 새 게임을 만들 때. 범위 근거: 공통 도구의 기본값 결함이라 어느 새 게임에서든 똑같이 생긴다.

## 관찰된 결함

### 편집 1 — 선택지 설명의 예시 수치를 확정값으로 씀 (G-007 재관찰)
- `RUN/reference/evidence.md` L4 (C1, 사용자 교정): 긴급 호출 선택지 설명에 에이전트가 "매치당 3회쯤"을 예시로 넣었고, 사용자는 횟수를 정하지 않은 선택지를 골랐다. 에이전트는 1절에 "매치당 3회"·"최대 123회"를 확정값처럼 썼다. 사용자: "매치당 호출 수는 왜 최대 123회지?" → "긴급 호출 횟수가 한 경기에 3번 얘기였구나?" 미정으로 되돌렸다.
- `RUN/reference/evidence.md` L5 (C2): 같은 "최대 123회" 설명에서 전제(실패 호출 재시도 없음, 세팅 변경은 호출 아님)가 빠졌다. C1의 예시 수치에서 나온 결과라 따로 편집하지 않았다(`RUN/candidates/invariant/RATIONALE.md` L8).
- `RUN/reference/evidence.md` L32 (자기 보고): G-007을 "구조"로만 읽고 "수치"에는 적용하지 않았다. 기존 문장의 빈틈이 원인이다.
- 원 항목: hsl L-007 `D:/game/hsl/harness/library/2026-10-24-s1-combat-core/EXPERIENCE.md` (`D:/game/hsl/harness/LESSONS.md` L14, 승격 → G-007).
- 재관찰: proxywar/2026-10-27-proxywar-kickoff
- 재관찰: proxywar/2026-10-27-proxywar-sim-core-1a

### 편집 3 — 다음 단계 제안에서 외부 서비스 이용 수단·비용을 단정 (G-005 재관찰)
- `RUN/reference/evidence.md` L8 (C5, 사용자 교정): 다음 단계 제안에서 "프로토타입 테스트에는 개발용 API 키와 호출 비용이 생긴다"고 단정했다. 사용자: "내 클로드 구독 못쓰나?" 조사해 보니 본인 PC의 `claude -p` 헤드리스로 개발 테스트가 가능해(공식 문구 미확인) 결정 기록을 고쳤다.
- 같은 줄: 앞선 질문(플레이어 구독 연동)에서는 G-005대로 조사했다(`RUN/reference/evidence.md` L29, WebSearch 4회·"미확인" 표기). 기존 문구("계획·설계서", "자산 이름·크기·설치 경로")가 닿는 자리에서는 지켰고 문구 밖 자리에서만 놓쳤다. 문구 범위가 원인이다(`RUN/DECISION.md` L9).
- `RUN/reference/evidence.md` L34 (자기 보고): 개발 단계의 외부 전제(테스트용 LLM 호출 수단)를 조사 없이 API 키로 가정했다.
- 원 항목: hsl L-005 `D:/game/hsl/harness/library/2026-10-23-s0-tech-foundation/EXPERIENCE.md` (`D:/game/hsl/harness/LESSONS.md` L12, 승격 → G-005).
- 재관찰: proxywar/2026-10-27-proxywar-kickoff

### 편집 4 — 등록된 게임 목록이 낡음 (사실 갱신)
- `RUN/task.md` L5: 이 과제에서 `tools/new-game.sh`로 proxywar를 만들었다. `D:/game/AGENTS.md` L8의 등록된 게임은 `hsl`뿐이다. Composer 확인: `ls D:/game/*/AGENTS.md` → hsl, proxywar(`RUN/DECISION.md` L10).

### 편집 5 — `new-game.sh`가 `master` 브랜치로 저장소를 만듦
- `RUN/reference/evidence.md` L12 (C9): `git init -q`가 `master`를 만들었다(hsl·공통 저장소는 `main`). 에이전트가 커밋 뒤 발견해 알렸고, 사용자가 `git branch -m master main`을 요청해 바로잡았다(`RUN/task.md` L5).
- `RUN/candidates/domain/RATIONALE.md` L3, `RUN/DECISION.md` L11 (Composer 확인): 전역 `init.defaultBranch` 미설정, git 2.45.1(`-b`는 2.28+), `git init -q -b main` → `refs/heads/main` 실측, composed 파일 `bash -n` 통과.

## 편집

`patch/`는 `RUN/composed/common/`을 그대로 복사했다(`diff -r` 같음). 보류한 2·6은 composed에 없다.

- `patch/AGENTS.md` → `D:/game/AGENTS.md`: L8 등록된 게임에 `proxywar`(2026-10-27 `tools/new-game.sh`로 생성) 추가(편집 4). L22 G-007 문장에 "에이전트가 먼저 정한 구조·수치(선택지 설명에 넣은 "매치당 3회쯤" 같은 예시) … 사용자가 그 선택지를 골랐어도 예시 수치는 미정이다" 추가(편집 1). L29 G-005 문장의 자리를 "계획·설계서·다음 단계 제안"으로, 예시에 "외부 서비스의 이용 수단·비용" 추가(편집 3). 출처 주석은 기존 `<!-- G-007 -->`·`<!-- G-005 -->` 그대로.
- `patch/tools/new-game.sh` → `D:/game/tools/new-game.sh`: L17 `git -C "$dest" init -q` → `git -C "$dest" init -q -b main`, L2 머리 주석에 "main 브랜치" 표기(편집 5).

## 효과

미검증 · 사용자 채택 (probe-less, 네 축 비교 없음).
1·3·5는 사용자가 세션 안에서 바로잡은 지점에 직접 대응한다. 1·3은 두 게임(hsl·proxywar) 다음 세션부터 상위 AGENTS.md 자동 로드로 적용되고, 5는 앞으로 만드는 게임에만 닿는다(`RUN/DECISION.md` L26·L27). 다음 브레인스토밍에서 예시 수치가 확정값으로 다시 쓰이거나, 제안 속 외부 서비스 전제가 조사 없이 단정되면 이 확장이 막지 못했다는 반증으로 기록한다.

## 상태

| 편집 | 교훈 ID | 상태 | 비고 |
|---|---|---|---|
| 1 | G-007 (기존 행 갱신) | 채택 | 공통 `LESSONS.md` G-007 행의 적용 조건·교훈·항목 열 갱신 |
| 3 | G-005 (기존 행 갱신) | 채택 | 공통 `LESSONS.md` G-005 행의 적용 조건·교훈·항목 열 갱신 |
| 4 | 없음 | 채택 | 사실 갱신, 교훈 아님 |
| 5 | 없음 | 채택 | 도구 수정으로 결함 자체가 없어지고 에이전트가 기억할 판단이 남지 않아 색인 행을 두지 않는다. 라이브러리 기록만 |
| 2 | 없음 | 보류 | 아래 참고. patch·색인 없음 |
| 6 | 없음 | 보류 | 아래 참고. patch·색인 없음 |

### 보류 — 편집 2: 스킬 체크리스트의 커밋 단계는 요청이 아님
- 편집: `AGENTS.md` "요청 없이 `git commit`" 줄에 "스킬 체크리스트의 커밋 단계(brainstorming의 "설계 문서를 쓰고 커밋" 같은)는 요청이 아니다"를 덧붙임(`RUN/candidates/invariant/patch/common/AGENTS.md` L26).
- 근거: `RUN/reference/evidence.md` L13 (C10). 에이전트가 이미 AGENTS.md를 따라 커밋하지 않았고 실제 문제는 없었다. 사용자가 나중에 커밋을 요청한 것은 정상 흐름이지 교정이 아니다(`RUN/DECISION.md` L8).
- 범위는 공통이 맞다(brainstorming은 사용자 전역 스킬이라 어느 게임에서든 같은 충돌이 생김).
- 번호: 나중에 채택되면 G-009 후보였다. 번호는 점유하지 않았다. 채택될 때 그 시점 공통 색인의 다음 빈 번호를 쓴다.

### 보류 — 편집 6: 템플릿 AGENTS.md에 설계서·보고서 위치 줄 추가
- 편집: `templates/game/AGENTS.md` "어디에 무엇이 있나"에 `docs/superpowers/specs/`·`plans/`(설계서·구현 계획), `docs/archive/reports/`(`design-report` HTML 보고서) 두 줄 추가(`RUN/candidates/domain/patch/common/templates/game/AGENTS.md` L13·L14).
- 근거: `RUN/reference/evidence.md` L22는 "변경" 절의 관찰이고 사용자가 바로잡은 지점이 아니다. 에이전트가 스스로 줄을 넣어 실패·재작업·사용자 개입이 없었다(`RUN/DECISION.md` L12). 같은 문장이 두 게임에 있다는 것(`D:/game/hsl/AGENTS.md` L16·L17, `D:/game/proxywar/AGENTS.md` L13·L14)은 내용이 겹친다는 뜻이지 결함이 재발한다는 뜻은 아니다.

### 게임 범위로 따로 기록한 것
어느 후보도 편집으로 내지 않은 C3·C4·C6·C7(`RUN/reference/evidence.md` L6·L7·L9·L10)은 첫 관찰이라 게임 범위로 `D:/game/proxywar/harness/library/2026-10-27-proxywar-kickoff/EXPERIENCE.md`에 기록했다(`RUN/DECISION.md` L17).
