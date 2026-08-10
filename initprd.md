# ZenMath — Initial PRD Brief

> Use this file with `flutter-design-taste` skill in a new chat to generate full PRD.md, ROADMAP.md, and RULES.md.

---

## App Name
**ZenMath**

## Package
`com.akashiverse.zenmath`

## One-Liner
Maths practice and learning app with progress tracking, evaluation, and growth — fully offline.

## Target Platform
Android (phone-first). Fully offline — no internet required at runtime.

## Build Setup
- Flutter 3.44.0 (stable), cloud builds via GitHub Actions
- No local Flutter SDK — all builds happen on GitHub
- Repo: `https://github.com/liebertjohan-art/zenmath` (public)

---

## Core Concept

ZenMath ek maths practice app hai jo user ko daily maths practice karne mein help karega. Ye boring textbook wali maths nahi hai — ye engaging, gamified, aur visually premium experience hogi.

### What It Is
- Daily maths practice — addition, subtraction, multiplication, division se start
- Progressive difficulty — easy → medium → hard → expert
- Topics unlock hote rahenge jaise user grow karega
- Progress tracking with stats, streaks, aur growth graphs
- Evaluation system — har topic pe user ka level track hoga
- Fully offline — sab data local storage mein

### What It Is NOT
- Ye calculator app nahi hai
- Ye tutor app nahi hai (no lessons, sirf practice)
- Ye online multiplayer nahi hai
- Ye generic boring blue-white maths app nahi hai

---

## Core Features (Initial Vision)

### P0 — Must Have (MVP)
- [ ] **Practice Mode** — topic select karo, questions solve karo, instant feedback
- [ ] **Topics** — Basic arithmetic (add, subtract, multiply, divide)
- [ ] **Difficulty Levels** — Easy / Medium / Hard per topic
- [ ] **Score System** — correct/incorrect tracking per session
- [ ] **Home Screen** — topic selection grid with progress indicators
- [ ] **Results Screen** — session summary after practice

### P1 — Should Have
- [ ] **Progress Tracking** — overall stats, topic-wise accuracy, improvement over time
- [ ] **Streak System** — daily practice streak with streak counter
- [ ] **Local Storage** — all data persisted locally (SharedPreferences / Hive / SQLite)
- [ ] **Growth Graph** — visual chart showing improvement over days/weeks

### P2 — Nice to Have (Future)
- [ ] **More Topics** — percentages, fractions, decimals, algebra basics, squares/cubes
- [ ] **Timed Challenges** — solve X problems in Y seconds
- [ ] **XP / Level System** — gamification with XP points and user level
- [ ] **Achievements / Badges** — unlock achievements for milestones
- [ ] **Custom Practice** — user configures difficulty, number range, time limit
- [ ] **Daily Challenge** — one special challenge per day

---

## Design Direction (for flutter-design-taste skill)

### Personality
- **Calm but confident** — "Zen" in the name means peaceful, focused
- App should feel like a zen garden meets a sleek modern dashboard
- NOT childish, NOT gamey-cartoony — think premium adult learning tool
- Dark mode primary, warm accent colors

### Vibe References
- Duolingo's gamification (but way more premium, less childish)
- Apple Fitness+ rings and progress tracking (clean, motivating)
- Headspace's calm aesthetic (peaceful but purposeful)

### Anti-Generic Mandate
- NO default Material blue
- NO boring flat list of topics
- NO generic progress bars
- NO template-looking screens
- "Kill the generic, add a living spirit"

---

## Tech Notes
- State management: TBD (Provider / Riverpod / Bloc — decide in PRD)
- Local storage: TBD (SharedPreferences / Hive / SQLite — decide in PRD)
- No network calls, no APIs, no backend
- Target: Android phones, min SDK as per Flutter default

---

## Instructions for New Chat

1. Open new chat
2. Say: "use flutter-design-taste skill"
3. Share this file or its contents
4. Ask: "Generate PRD.md, ROADMAP.md, and RULES.md for ZenMath based on this brief"
5. Review and iterate
