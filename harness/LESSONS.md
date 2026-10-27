# LESSONS — 공통 색인 (G-NNN)

모든 게임에 해당하는 교훈만 둔다. 게임 고유 교훈은 각 게임의 `harness/LESSONS.md`(L-NNN).
형식: `| ID | 적용 조건 | 교훈 (한 줄) | 상태 | 항목 |`. 상태는 채택 / 보류 / 폐기. 근거가 실행 대비나 사용자 교정으로 뒷받침될 때만 추가한다.
G-001~G-008은 hsl에서 옮겼다(2026-10-25). 원 근거는 항목 열의 hsl 라이브러리 파일이다.

| ID | 적용 조건 | 교훈 | 상태 | 항목 |
|---|---|---|---|---|
| G-001 | 사용자에게 묻는 모든 메시지(wrap_up 질문·버튼, 부가 질문) — 모든 과제 | 사용자가 채워 넣어야 완성되는 질문·버튼 메시지를 쓰지 않는다. 그대로 눌러도(답해도) 완결된 답이 되게 쓴다. | 채택 | hsl L-001 `D:/game/hsl/harness/library/2026-10-23-harness2-design/EXPERIENCE.md` |
| G-002 | 하네스·설정 파일을 만들거나 고치는 세션 | `CLAUDE.md`는 두지 않는다. Claude Code는 `AGENTS.md`와 상위 폴더의 `AGENTS.md`를 자동 로드한다(2.1.291, 2026-10-25 재확인). | 채택 | hsl L-002 `D:/game/hsl/harness/library/2026-10-23-harness2-design/EXPERIENCE.md`; 상위 폴더 로드는 `docs/specs/2026-10-25-common-harness-design.md` §2 |
| G-003 | 하네스 파일 편집 전반(Proposer 후보 작성, 기본 하네스 작성·재작성) | 편집은 추가만이 아니다. 근거 없이 남아 있거나 결함을 낳은 기존 문장의 삭제·축소도 같은 자격의 편집이며, 더하기 전에 뺄 것이 있는지 먼저 본다. | 채택 | hsl L-003 `D:/game/hsl/harness/library/2026-10-23-harness2-design/EXPERIENCE.md` |
| G-004 | 승인된 설치·다운로드·실행이 있는 과제, 설계서·계획에서 실행 주체를 정하는 단계 | 승인 뒤의 설치·다운로드·실행은 사용자에게 넘기지 않고 에이전트가 한다. 설계서·계획에 "사용자 실행"을 두지 않고, UAC·샌드박스에 막히면 우회를 먼저 한다. | 채택 | hsl L-004 `D:/game/hsl/harness/library/2026-10-23-s0-tech-foundation/EXPERIENCE.md` |
| G-005 | 설계서·계획·다음 단계 제안이 외부 자산·도구·서비스(릴리스 파일, 템플릿, addon, 설치 경로, 외부 서비스의 이용 수단·비용)를 전제로 삼는 과제 | 계획·설계서·다음 단계 제안에 외부 전제(자산 이름, 크기, 설치 경로·방법, 외부 서비스의 이용 수단·비용)를 확인 없이 "있을 것"으로 적지 않는다. 실행 전에 API·HEAD로 조회해 근거를 적고, 못 확인한 것은 "미확인"으로 표기한다. | 채택 | hsl L-005 `D:/game/hsl/harness/library/2026-10-23-s0-tech-foundation/EXPERIENCE.md`; 재관찰·확장(다음 단계 제안, 외부 서비스) proxywar `D:/game/harness/library/proxywar/2026-10-27-proxywar-kickoff/EXPERIENCE.md` |
| G-006 | 검증 결과로 완료·커밋을 판단하는 모든 작업, 특히 에이전트가 직접 한 수정 | 검증 출력을 읽지 않고 완료·커밋으로 넘기지 않는다. 서브에이전트에 요구하는 "확인 출력을 보이라"는 규율은 직접 한 수정에도 같다. | 채택 | hsl L-006 `D:/game/hsl/harness/library/2026-10-23-s0-tech-foundation/EXPERIENCE.md` |
| G-007 | 브레인스토밍 질문 선택지·추천·설계서 절을 쓰는 모든 과제, 특히 상위 설계서에 분해·범위 문구가 있거나 선택지 설명에 예시 수치를 넣을 때, 다른 게임의 선례를 근거로 삼거나 추천을 좌우하는 상위 요구(대상 플랫폼, 서비스 범위, 결과물을 다시 쓸 곳)가 기록에 없을 때 | 질문·추천·설계 절의 전제는 그 게임의 확정 결정 기록(결정 로그·ADR)뿐이다. 상위 설계서의 분해·범위 문구, 에이전트가 먼저 정한 구조·수치(선택지 설명에 넣은 예시 — 사용자가 그 선택지를 골랐어도 미정), 다른 게임의 선례로 선택지를 좁히거나 절을 쓰기 전에 묻는다. 추천을 좌우하는 상위 요구가 기록에 없으면 추천보다 그것을 먼저 묻는다. | 채택 | hsl L-007 `D:/game/hsl/harness/library/2026-10-24-s1-combat-core/EXPERIENCE.md` (문서 이름만 일반화); 재관찰·확장(예시 수치) proxywar `D:/game/harness/library/proxywar/2026-10-27-proxywar-kickoff/EXPERIENCE.md`; 재관찰·확장(추천, 다른 게임 선례, 상위 요구) proxywar `D:/game/harness/library/proxywar/2026-10-27-proxywar-sim-core-1a/EXPERIENCE.md` |
| G-008 | `harness-reflect`를 안내하거나 시작하는 때(매 과제 끝) | harness-reflect는 요청 시 시작하고 0~3단계를 자동 진행한다. 사용자에게 명령을 직접 입력시키거나 단계마다 묻지 않는다(묻는 곳은 1·4·6단계). | 채택 | hsl L-008 `D:/game/hsl/harness/library/2026-10-24-s1-combat-core/EXPERIENCE.md` |
