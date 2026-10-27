---
name: chatgpt-connector-review
description: 수동 전용 — 사용자가 외부 리뷰를 요청할 때만 쓴다. push된 브랜치의 설계서·계획·코드 diff를 ChatGPT 웹 GitHub 커넥터로 리뷰시키고, 고정 VERDICT 포맷을 파싱해 반영-재리뷰 루프를 돈다.
---

# ChatGPT 커넥터 리뷰

push된 브랜치 산출물을 ChatGPT 웹(GitHub 커넥터)에게 리뷰시키고, 고정 `VERDICT` 포맷을 파싱해
실제 PASS 또는 라운드 캡 판정 종결(§3-f)까지 반영-재리뷰한다. Quant 프로젝트의 같은 이름 스킬을 옮겨 왔다(2026-10-23). 브라우저 조작 함정 모음(§5)은 실측 기록이므로 그대로 둔다.

- ChatGPT **Chat 모드**를 쓴다 — 구독 안이라 추가 비용이 없다. 유료 API · 다른 리뷰 도구로 바꾸지 않는다(사용자 결정).
- 외부로 나가는 통로는 `git push` 뿐이다. 리뷰어는 push된 커밋만 읽는다. **GitHub 원격이 없으면 이 스킬은 쓸 수 없다** — 사용자에게 알리고 멈춘다.
- 리뷰어는 read-only 다. ChatGPT 에 파일 쓰기를 시키지 않는다.
- 리뷰 여부·대상·라운드 캡은 사용자가 호출할 때 정한다. 이 스킬은 수행 방법만 정한다.

## 0. 리뷰 모델 · 추론량 · 제한시간

- 모드 **Chat** · 모델 **GPT-6** · 추론량 **`MEDIUM`** 고정. 산출물 종류·위험도와 무관하다.
- 새 채팅마다 셋을 확인한다(§5-2). 확인하지 못하면 리뷰를 시작하지 않고 park+flag. Work 모드면 묻지 말고 Chat 으로 바꾼다.
- `POLL_TIMEOUT_SECONDS` = **900초** 고정. 폴링 간격은 §2C.

## 1. VERDICT 계약

리뷰 프롬프트는 ChatGPT 에게 아래 출력 규칙을 지키게 한다.

- 문제마다 한 줄: `- [BLOCKER|MAJOR|MINOR] <경로>:<라인 또는 -> — <문제> → <제안>`
- **마지막 줄은 둘 중 하나만**: `VERDICT: PASS` 또는 `VERDICT: CHANGES_REQUESTED`. `CHANGES_REQUESTED` 면 findings 최소 1개.
- **severity**: `BLOCKER`/`MAJOR` = 진행 차단(반영 또는 기각 판정 필수) · `MINOR` = 비차단.
  BLOCKER/MAJOR 가 없고 MINOR 만 남으면 리뷰어는 `VERDICT: PASS` 를 내고 잔여 MINOR 를 나열한다.
- **결함 카탈로그**: 리뷰어에게 먼저 찾게 하는 결함 유형. Quant 의 카탈로그는 그 프로젝트의 실제 결함 145건에서 나온 것이라 그대로 쓰지 않는다. 게임마다 카탈로그는 비어 있고, 그 게임의 `harness/LESSONS.md` 와 실제 리뷰 findings 가 쌓이면 거기서 뽑아 §2A 프롬프트에 넣는다. 그때까지 프롬프트는 일반 관점(정확성 · 내부 모순 · 누락 · 범위 위반)만 쓴다.
- **외부 전제**(DESIGN 문서): 설계의 "외부 전제" 절에서 **근거(확인 날짜 · 방법)가 없는 전제**, 그리고 절에 **빠진** 외부 동작 가정(엔진 API 동작 · Steamworks · 에셋 라이선스 · 플랫폼 요건 등)은 `BLOCKER` 다. 설계서에 "외부 전제" 절이 없으면 리뷰 전에 추가한다.
- **DOC 심도 계약**(design/plan 문서만): 판정 대상은 구조 · 계약 경계 · 안전 불변식 · 외부 전제 · 문서 내/간 모순까지다.
  구현 수준 지적(세부 상태 전이 · 동시성 · 성능 · 표기 정합)은 `- [IMPL-REVIEW] ...` 줄로 따로 적고 VERDICT 에 넣지 않는다.
  이유: 리뷰어가 라운드마다 한 층씩 내려가며 구현 수준 MAJOR 를 끝없이 공급해 PASS 가 구조적으로 불가능해진다(Quant 에서 설계 리뷰 24라운드). CODE 리뷰에는 이 제한이 없다.
- **`(2차)` 표시**: 직전 라운드 반영이 새로 만든 공백을 지적할 때 finding 끝에 `(2차)` 를 붙인다 — §3-c4 재작성 규칙의 입력.
- **라운드 범위 잠금**(라운드 2 이상, DOC·CODE 공통): 판정 대상은 (a) 직전 findings 해소 여부와 (b) 직전 반영이 유발한 신규 문제로 한정한다.
  무관한 새 영역 지적은 `- [NEW-SCOPE] ...` 줄로 따로 적고 VERDICT 에 넣지 않는다. 라운드 1은 전체 범위다.

### 파스 규칙
1. `captured` = 마지막 어시스턴트 메시지 본문(§5-5).
2. `verdict` = `^VERDICT:\s*(PASS|CHANGES_REQUESTED)\s*$`(멀티라인)의 **마지막** 매치.
3. `findings` = `^\s*-?\s*\[(BLOCKER|MAJOR|MINOR)\]\s*(.+)$` 전체 매치. 선행 `-` 는 optional — 마크다운 불릿으로 렌더되면 `- ` 가 떨어진다.
4. `implReview` = `^\s*-?\s*\[IMPL-REVIEW\]\s*(.+)$`, `newScope` = `^\s*-?\s*\[NEW-SCOPE\]\s*(.+)$` — verdict·게이트에 반영하지 않고 이월 목록으로 쌓는다(버리지 않는다).
5. `CHANGES_REQUESTED` 인데 findings 가 비었거나 `VERDICT` 줄이 없으면 먼저 §5-5 재판독. 그래도면 **malformed** → 재프롬프트 1회("VERDICT 포맷 위반, findings 포함해 다시") → 그래도면 park.

### self-check
| captured 끝부분 | 기대 verdict | findings 수 |
|---|---|---|
| `...\nVERDICT: PASS` | `PASS` | 0 |
| `- [MAJOR] docs/x.md:12 — 모순 → 정정\nVERDICT: CHANGES_REQUESTED` | `CHANGES_REQUESTED` | 1 |
| `- [BLOCKER] a:- — 누락 → 추가\n- [MINOR] b:3 — 오타 → 수정\nVERDICT: CHANGES_REQUESTED` | `CHANGES_REQUESTED` | 2 |
| `VERDICT: CHANGES_REQUESTED` (findings 없음) | malformed → 재프롬프트 | — |
| (VERDICT 줄 없음) | 재판독 → malformed → 재프롬프트 | — |

## 2. 리뷰 서브루틴 (입력: REPO, BRANCH, ARTIFACT_SPEC, HEAD_SHA, SESSION{tabId?}, FIX_SUMMARY?, CARRYOVER? → 출력: {verdict, findings[], tabId})

`REPO` 는 `git remote get-url origin` 에서 `owner/name` 으로 뽑는다.

**한 리뷰는 한 채팅 세션으로 이어간다.** 라운드 1은 새 채팅, 라운드 2 이상은 같은 `tabId` 에 후속 메시지.
리뷰어가 이전 리뷰·반영을 기억해 증분 리뷰가 되고 수렴한다(매 라운드 새 채팅이면 라운드마다 다른 findings 가 나와 수렴하지 않았다).
세션 안에서도 매 라운드 최신 커밋을 다시 읽게 하고 `SHA-READ` 로 교차 검증한다(커넥터 stale-read 방지).

`ARTIFACT_SPEC` 이 커밋 범위(`BASE_SHA..HEAD_SHA` diff)면 **CODE**, 문서 경로면 **DOC** 다.
`CARRYOVER` 는 직전 리뷰가 `ADJUDICATED` 로 끝났을 때 외부 리뷰 없이 들어간 반영 커밋 범위다.

프롬프트 입력 · 전송 · 판독은 모두 §5 의 JS 경로로 한다.

### 2A. 라운드 1 (새 세션)
1. `tabs_create_mcp` 로 새 탭 → `navigate` `https://chatgpt.com/` → 로그인 화면이나 CAPTCHA/챌린지면 자동 해결하지 않는다 → `AskUserQuestion`("ChatGPT 로그인/CAPTCHA 필요 — 처리 후 계속").
2. §5-1 초안 비우기 → §5-2 모드 · 모델 · 추론량 확인 → §5-3 GitHub 커넥터 칩 부착.
3. 프롬프트(치환: REPO · BRANCH · ARTIFACT_SPEC · HEAD_SHA):

   ```
   <REPO> 레포 <BRANCH> 브랜치를 커밋 <HEAD_SHA> 기준으로 리뷰하라. 대상: <ARTIFACT_SPEC>.
   관점: 정확성 · 내부 모순 · 누락 · 범위 위반. 근거 없는 칭찬 금지.
   먼저 실제로 읽은 커밋 SHA를 한 줄로 밝혀라: SHA-READ: <sha>
   출력 규칙(엄수):
   - 문제마다 한 줄: - [BLOCKER|MAJOR|MINOR] <경로>:<라인 또는 -> — <문제> → <제안>
   - 마지막 줄에 반드시 하나만: VERDICT: PASS  또는  VERDICT: CHANGES_REQUESTED
   - CHANGES_REQUESTED이면 findings 최소 1개.
   - BLOCKER/MAJOR가 하나도 없고 MINOR만 남으면 VERDICT: PASS를 내되 잔여 MINOR를 나열하라.
   ```

   `harness/LESSONS.md` 에서 뽑은 결함 카탈로그가 있으면 "관점" 줄 뒤에 "아래 결함 유형을 먼저 찾되, 목록 밖의 결함도 찾아라:" 와 번호 목록을 넣는다.

   DOC 이면 덧붙인다(CODE 는 생략):

   ```
   심도 규칙: 이것은 설계 문서 리뷰다. BLOCKER/MAJOR/MINOR 판정 대상은 구조·계약 경계·안전 불변식·외부 전제·문서 내/간 모순까지다.
   세부 상태 전이·동시성·성능·문서 표기 정합 같은 구현 수준 지적은
   - [IMPL-REVIEW] <경로>:<라인> — <내용> 형식으로 별도 나열하고 VERDICT 판정에는 반영하지 마라(구현 단계 리뷰로 이월된다).
   직전 반영이 새로 만든 공백을 지적할 때는 finding 끝에 (2차)를 붙여라.
   ```

   DESIGN 문서면 덧붙인다:

   ```
   외부 전제 규칙: 문서의 "외부 전제" 절에서 근거(확인 날짜·방법)가 없는 전제, 그리고 절에 빠진 외부 동작 가정
   (엔진 API·Steamworks·에셋 라이선스·플랫폼 요건 등)은 BLOCKER 로 지적하라.
   ```

   `CARRYOVER` 가 있으면 덧붙인다:

   ```
   직전 리뷰 없이 반영하고 끝난 변경 <CARRYOVER> 도 같은 기준으로 검토하라.
   ```
4. §5-4 로 삽입 · 검증 · 전송 → **2C**.

### 2B. 라운드 2 이상 (세션 연속)
1. 새 탭 · 커넥터 재부착 금지 — 기존 `tabId` 재사용(커넥터는 이미 붙어 있다).
2. 후속 메시지(치환: FIX_SUMMARY · BRANCH · HEAD_SHA):

   ```
   직전 findings를 반영했다: <FIX_SUMMARY>.
   <BRANCH>를 커밋 <HEAD_SHA> 기준으로 다시 읽어 재리뷰하라(최신 커밋 재fetch 필수).
   실제로 읽은 커밋 SHA를 밝혀라: SHA-READ: <sha>
   반영이 findings를 해결했는지 + 반영이 유발한 신규 문제를 포함해 판정하라.
   판정 범위는 위 두 가지로 한정한다. 직전 라운드와 무관한 새 영역 지적은
   - [NEW-SCOPE] <경로>:<라인> — <내용> 형식으로 별도 나열하고 VERDICT 판정에 반영하지 마라.
   출력 규칙은 동일. BLOCKER/MAJOR 0 + MINOR만이면 VERDICT: PASS.
   ```
   §3-c4 재작성 직후 라운드는 범위 잠금 문장을 빼고 "재작성본 전체 재리뷰" 로 바꾼다.
3. §5-4 로 삽입 · 검증 · 전송 → **2C**.

### 2C. 공통 (폴링 · 회수 · SHA 검증 · 파스)
1. **완료 폴링**: 폴 사이 대기는 `Start-Sleep -Seconds <간격>`(포그라운드)으로 실제 벽시계를 흘린다 — 브라우저 `wait` 어림이나 백그라운드 sleep 이 아니다.
   완료 확인은 JS 한 번으로 `stop-button` 부재 + 마지막 어시스턴트 메시지에 `VERDICT:` 등장을 본다(짧게 읽는다). 폴링에 `screenshot` 은 쓰지 않는다.
   - DOC: 첫 대기 **20초** → 이후 **30초** 간격.
   - CODE: 첫 대기 **60초** → 이후 **45초** 간격.
   첫 대기 동안은 읽지 않는다. **900초** 넘으면 §5-6 을 먼저 보고, 그래도면 incomplete → park+flag.
2. 완료 감지 뒤 `captured` 전체를 회수한다(§5-5).
3. **SHA-READ 검증**: `SHA-READ` 가 요청한 `HEAD_SHA` 와 다르면 먼저 §5-5 재판독(잘린 `SHA` 는 stale 렌더다). 그래도 다르면 stale-read → 후속 메시지 1회로 "최신 `<HEAD_SHA>` 재fetch 후 재판정" 요구 → 그래도 다르면 park+flag. stale 리뷰의 verdict/findings 는 믿지 않는다. `SHA-READ` 줄이 없으면 재프롬프트 1회로 요구.
4. §1 파스 규칙으로 `{verdict, findings[]}` 산출.
5. `{verdict, findings, tabId}` 반환 — 다음 라운드가 `tabId` 로 세션을 잇는다.

## 3. 드라이버 루프

입력: `BRANCH`, `ARTIFACT_SPEC`, `ROUND_CAP`(사용자가 호출 시 지정. 기본값 DOC 2 · CODE 3), `CARRYOVER?`.
출력: 게이트 종결 + (ADJUDICATED 면) 외부 리뷰 없이 반영한 커밋 범위.

종결 경로는 셋뿐이다: (a) 캡 안의 실제 `VERDICT: PASS`, (b) 캡 소진 뒤 §3-f **판정 종결 `ADJUDICATED`**, (c) §4 에러 park.
severity 만 보고 자동 통과시키는 경로(effective-PASS)는 없다. 캡은 외부 라운드 수의 상한이지 반영 의무의 상한이 아니다.

**제출 전제**: 산출물을 스스로 한 번 읽어 빈칸 · 모순 · 범위 이탈 · 근거 없는 외부 전제를 고친 뒤 push 한다. 리뷰어는 실행을 못 하므로 코드면 테스트를 먼저 통과시킨다.

1. 산출물 커밋 + push(`git push origin <BRANCH>`) — 커밋·push 는 사용자가 요청한 리뷰의 일부로 간주한다. `HEAD_SHA = git rev-parse HEAD`.
2. `tabId = null` · `FIX_SUMMARY = null` · `iter = 0` · `sessionResets = 0` · `accepted = 0` · `rejected = 0` · `secondary = 0` · `rewritten = false`.
3. `iter < ROUND_CAP` 인 동안(`iter += 1`):
   a. §2 실행 → `{verdict, findings, tabId}`. `tabId` 보존.
   b. `PASS` → `HEAD_SHA` + "VERDICT: PASS" 기록 후 종료. 잔여 MINOR 는 이월 백로그로 기록.
   c. `CHANGES_REQUESTED` → findings 를 severity 무관 전부 검증 규율로 처리한다 — 지적을 그대로 받지 않고, 이 코드베이스에서 맞는지 · 기존 기능을 깨지 않는지 · 확정 결정과 부딪히지 않는지를 코드·실측·테스트로 확인해 타당하면 반영, 부당하면 기각. 불분명한 지적이 있으면 나머지도 반영하기 전에 그것부터 묻는다(항목끼리 얽혀 있을 수 있다).
      기각은 원장(`harness/runs/<과제 ID>/review-ledger.md`)에 finding 원문 + 사유 한 줄(같은 지적 재적용 금지). `accepted`/`rejected` 에 센다.
      반영 커밋 + push → `HEAD_SHA` 갱신 → `FIX_SUMMARY` = 반영 요약 + 기각 목록 → 계속.
      MINOR 만 남은 `CHANGES_REQUESTED` 는 §1 계약 위반 → 반영하거나 기각 사유를 붙여 재판정을 요구하고 계속한다.
   c2. **CODE BLOCKER/MAJOR 는 RED 시험부터**: 반영 전 코드에서 **실패하는** 시험을 먼저 쓰고(RED 를 실제로 돌려 확인), 고친 뒤 GREEN 을 확인한다. 원장에 finding 별 시험 이름을 적는다.
       RED 를 만들 수 없으면 결함이 입증되지 않은 것이다 — 기각 후보로 다시 판정한다. 시험으로 표현할 수 없는 지적(로그 문구 · 문서 · 설정 값 등)만 사유를 적고 예외로 한다.
       이유: Quant 에서 기각률 3.5% — 드라이버가 지적을 검증 없이 받는 순응 모드였다. RED 시험은 지적이 진짜임을 증명하고 같은 결함의 재발도 막는다.
   c3. `[IMPL-REVIEW]`·`[NEW-SCOPE]` 는 verdict 와 무관하게 이월 목록으로 쌓는다.
   c4. **`(2차)` 재작성**: `(2차)` BLOCKER/MAJOR 를 `secondary` 에 센다. **2건이 되면 패치를 멈추고** 지금까지의 findings(반영·기각·이월 포함)를 제약 목록으로 삼아 산출물을 **처음부터 다시 쓴다**(`rewritten = true`, 리뷰 당 1회).
       패치가 패치를 부를 때 다섯 번 덧대는 것보다 한 번 다시 쓴 문서가 일관된다.
       재작성본도 제출 전제를 다시 거친 뒤 push 하고, 다음 라운드는 같은 세션에서 전체 범위로 요청한다(§2B 끝 문장).
       **재작성 뒤 재리뷰 1라운드는 캡에 세지 않는다**(상한 캡+1). 이미 재작성했는데 `(2차)` 가 또 2건 쌓이면 §3-f 로 간다.
   d. malformed 는 서브루틴 안에서 재판독 → 재프롬프트 1회. 같은 라운드 2회 연속이면 park+flag.
   e. **세션 열화**: iter 가 3을 넘고 응답 품질이 눈에 띄게 떨어지거나 맥락을 잃은 정황이면 `tabs_close_mcp` 로 닫고 `tabId = null`(`sessionResets += 1`). 새 세션 라운드 1은 전체 범위다. 연속 2회면 커넥터 이상으로 보고 park+flag.
   f. **캡 소진 → `ADJUDICATED`**: `iter == ROUND_CAP` 인데 마지막 verdict 가 `CHANGES_REQUESTED` 면 외부 라운드를 더 열지 않는다.
      잔여 BLOCKER/MAJOR 를 finding 별로 c 의 검증 규율로 판정한다 — 타당하면 반영(커밋 + push, CODE 면 c2 의 RED 시험), 부당하면 기각(원장에 원문 + 사유). 잔여 MINOR 는 이월 백로그.
      원장에 `GATE: ADJUDICATED · rounds=<iter> · accepted=<n> · rejected=<m> · unreviewed=<마지막 리뷰 SHA>..<HEAD>` 를 적고 종료. `unreviewed` 범위가 다음 리뷰의 `CARRYOVER` 다.
      판정 없이 `ADJUDICATED` 를 적는 것은 금지 — 남은 finding 을 조용히 버리는 경로가 아니다.
   g. **기각 0 점검**: 루프 종료 시 `rejected == 0` 이면 원장에 `REJECTED_NONE` 을 적고 사용자에게 보고한다. 리뷰어가 무오류일 확률보다 드라이버가 순응 모드일 확률이 높다(Quant 34건 중 32건이 기각 0, 그중 한 반영은 회귀였다).

## 4. 에러 처리
- CAPTCHA/챌린지 · 로그인 만료 → 자동 해결 금지 → `AskUserQuestion` 으로 멈췄다가 재개(park 아님).
- 커넥터 빈 응답 / 브랜치를 못 봄 → 짧게 기다린 뒤 1회 재시도 → 실패 시 park+flag.
- 폴링 900초 초과 → §5-6 확인 → 그래도면 incomplete → park+flag.
- stale-read → §2C-3 재촉 1회 → 실패 시 park+flag.
- malformed 2연속 · 세션 재시작 2연속 → park+flag.
- 캡 소진은 에러가 아니라 §3-f 판정 종결이다. park 는 위 에러 경로뿐이다.
- park+flag = 진행을 멈추고 사용자에게 상태 · 마지막 SHA · 원장 경로를 보고한다. 게이트를 통과로 적지 않는다.

## 5. 브라우저 조작 (실측 함정 모음 — Quant 에서 그대로)

도구는 `mcp__claude-in-chrome__*` 다. 리뷰 탭은 대개 숨김(백그라운드) 상태라 **CDP 입력(`computer type` · 좌표 클릭 · `key Return`)은 믿지 않는다** — 숨김 탭에서 긴 글의 공백 · 영문 · 숫자 · SHA 가 탈락하고, 여러 줄은 첫 개행에서 바로 전송되고, `+` 메뉴는 아예 렌더되지 않는다.
**기본 경로는 `javascript_tool`** 이다. 숨김 상태에서도 정확히 동작한다. 한 JS 호출에는 대기를 한 번만 짧게 넣는다(숨김 탭 타이머가 조여져 긴 스크립트는 45초 상한에 걸린다). 발송 전 검증이 실패하면 보내지 않는 `if (ok) click` 가드를 유지한다.

1. **초안 비우기** — 홈 입력창 초안은 `localStorage` 로 모든 탭 · 모든 세션이 공유하고, JS 전송은 초안을 지우지 않는다. 컴포저(`#prompt-textarea`) 글자 수가 0 이 아니면: 사이드바 최신 대화(`nav a[href^="/c/"]`)를 **읽기만** 해서 첫 user 메시지가 그 초안과 같은지 본다. 같으면 찌꺼기 → `selectAll` + `delete`. 다르면 다른 세션이 작성 중일 수 있으니 손대지 말고 새 탭을 쓴다.
   기존 대화를 재사용하지 않는다 — 제목이 비슷한 대화가 다른 세션의 라이브 리뷰였던 적이 있다.
2. **모드 · 모델 · 추론량 확인** — 홈 상단의 `Chat`/`Work` 라디오(`button[role=radio]`)에서 Chat. 모드는 대화마다 고정이라 Work 대화는 Chat 으로 못 옮긴다 → 새 채팅. 컴포저 오른쪽 추론 수준 버튼(`aria-haspopup=menu`)은 ref · 좌표 클릭에 안 열리면 JS 로 `pointerdown` · `mousedown` · `pointerup` · `mouseup` + `click()` 을 차례로 보낸다. 판독은 `menuitemradio` 의 `aria-checked="true"`(GPT-6) + 추론 슬라이더(`[role=slider]`) 라벨 `Medium`(한글 UI 면 `중간`). 슬라이더 단계 수가 바뀐 적이 여러 번 있으니(3 · 4 · 5단계) 위치 번호가 아니라 **라벨**로 판정하고, 움직일 때는 합성 `ArrowLeft/Right` keydown. 기본 모델이 새 채팅에서 바뀌어 있던 적이 있다 — 매번 메뉴를 열어 본다. 숨김 탭에서는 버튼 글자가 `추론 수준` 뿐이라 버튼 글자로 판정하지 않는다.
3. **GitHub 커넥터 칩** — `+` 가 아니라 컴포저에 `@` 로 피커를 연다: 합성 `keydown`(key `@`, code `Digit2`, shiftKey) → `execCommand('insertText', false, '@')`. 이어 `insertText('GitHub')` 로 필터 → 컴포저에 합성 `keydown Enter` 로 선택. 붙었는지는 `#prompt-textarea span[contenteditable=false]` 존재로 확인한다(텍스트 `@GitHub` 만 남은 채 보낼 뻔한 적 있음).
4. **삽입 · 검증 · 전송은 호출을 나눈다** — (a) 커서를 끝으로 옮긴 뒤 `execCommand('insertText', false, PROMPT)` — 개행 포함 1,200자+ 한글도 무손실. `§` · `×` 같은 기호는 피한다. (b) 별도 호출로 전문 검증: `HEAD_SHA` 40자 · `VERDICT:` · 출력 규칙 · 칩 존재 · 삽입 길이. (c) 별도 호출로 `button[data-testid="send-button"]` 존재 확인 후 `.click()`. 전송 확인은 `location.href` 가 `/c/<id>` 로 바뀌고 사용자 메시지 수가 **기준치 대비** 늘었으며 마지막 사용자 메시지에 SHA 가 있는지로 한다(재진입 뒤 메시지 수는 가상화로 줄어 보인다).
   메뉴를 만진 직후 첫 `click()` 이 안 먹는 때가 있다 — 컴포저 전문이 그대로이고 메시지 수가 그대로일 때만 pointer/mouse 이벤트 + `click()` 을 한 번 더.
   도구가 `Detached while handling command` 를 내도 실제로는 입력돼 있을 수 있다 — 재입력 전에 JS 로 컴포저 상태를 먼저 본다.
5. **판독** — 마지막 `[data-message-author-role="assistant"]` 의 `innerText`. 스트리밍 탭의 DOM 은 첫 문단만 커밋된 채 멈출 수 있어 본문이 `SHA` 3글자처럼 잘려 보이고, 스크린샷도 같은 DOM 을 찍는다. **`VERDICT:` 가 없거나 부자연스럽게 짧으면 malformed 판정 전에 그 대화 URL 로 `navigate` 재진입 → 2초 뒤 재판독**한다(저장본은 온전했다). 본문에 `?` `&` `=` 가 든 쿼리 문자열이 있으면 도구가 `[BLOCKED: Cookie/query string data]` 로 가리므로 치환하고 350자 조각으로 읽는다. 스크린샷은 사이드바 대화가 많으면 30초 타임아웃하니 쓰지 않는다.
6. **멈춘 응답** — "연결이 끊어졌습니다 · 전체 답변을 기다리는 중" 상태:
   - 본문에 이미 `VERDICT:` 까지 있고 `stop-button` 만 남아 `send-button` 이 없으면: 판독을 **먼저** 끝내고 → "답변 중지"(`stop-button`) 클릭 → 다음 라운드 전송(중지 뒤 그 답변 노드는 비어 보일 수 있다).
   - 본문이 빈 채 재진입 3회 · 20분 넘게 그대로면: 기다리지 말고 새 채팅(라운드 1 전체 범위)으로 다시 발주한다.
7. **입력 경로가 완전히 죽은 상태** — JS 로도 삽입 · 전송이 안 되면 park+flag 하고 게이트를 통과로 적지 않는다.
