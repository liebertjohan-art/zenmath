# ZenMath — Development Roadmap

## Phase 0: Foundation (Design System + Architecture)
- [x] Initialize project with custom package name `com.akashiverse.zenmath`.
- [x] Configure GitHub Actions CI/CD for automated cloud builds.
- [x] Setup `Riverpod` for state management and `go_router` for navigation.
- [x] Integrate `Isar` database for local offline storage.
- [x] Define `ThemeData` with "Midnight Zen" `ColorScheme`.
- [x] Setup `TextTheme` hierarchy using `Outfit` and `Plus Jakarta Sans` (`google_fonts`).
- [x] Create design token constants (`ZenColors`, `ZenSpacing`, `ZenRadii`).
- [x] Build base wrapper widgets (`ZenScaffold`, `ZenCard`, `GlassBottomSheet`).

## Phase 1: MVP (Core Features & Flow)
- [ ] **Data Layer:** Define Isar schemas for `SessionScore`, `DailyProgress`, and `TopicStats`.
- [ ] **Home Screen:** Build the dashboard with static topic cards and a mockup progress ring.
- [ ] **Topic Selection:** Build the difficulty selection bottom sheet.
- [ ] **Practice Arena:** Build the core logic (question generation based on difficulty).
- [ ] **Custom Numpad:** Implement the `ZenNumPad` widget with haptics.
- [ ] **Results Screen:** Build the post-session summary screen.
- [ ] Connect the full flow: Home -> Select Difficulty -> Practice -> Results -> Home.

## Phase 2: Polish & Gamification (The Gold Layer)
- [ ] Implement actual Streak Tracking logic.
- [ ] Animate Home Screen topic cards (Staggered Entrance).
- [ ] Add `AnimatedSwitcher` for smooth question transitions in Practice Arena.
- [ ] Add wrong-answer shake animation and correct-answer soft glow.
- [ ] Integrate Haptic Feedback (`HapticFeedback.lightImpact()` on numpad, `mediumImpact` on completion).
- [ ] Implement the Growth Graph using `fl_chart` on the Home Screen.

## Phase 3: Expansion (Future P2 Features)
- [ ] Add more topics: Percentages, Fractions, Decimals, Algebra basics.
- [ ] Introduce Timed Challenges (Solve X in Y seconds).
- [ ] Add XP / Level System and unlockable achievements.
- [ ] Accessibility and Performance Audit (ensure 60/120fps smooth scrolling and rendering).
