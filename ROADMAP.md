# ZenMath — Development Roadmap (v2.0)

> **Previous Phases 0–3 are COMPLETE.** This roadmap starts fresh from the current state.
> All tasks below are the NEW work required for the redesign and feature expansion.

---

## Phase 4: Architecture Overhaul (Navigation + Theming)
> **Goal:** Rebuild the app skeleton — shell navigation, theme system, file structure.
> **Priority:** P0 — Nothing else works without this.

- [x] **Restructure file system** — Rename `home/` → `play/`, create `history/`, `stats/`, `settings/` feature dirs.
- [x] **Create `zen_design_tokens.dart`** — `ThemeExtension<ZenDesignTokens>` with ALL color, spacing, radius tokens.
- [x] **Overhaul `zen_colors.dart`** — New dark palette (`#0A0A0F` background, `#14141F` surface, etc.) + full light palette (`#F8F7F4` background).
- [x] **Create `zen_typography.dart`** — Centralized TextStyle definitions with optical sizing (negative tracking on large, positive on small).
- [x] **Overhaul `app_theme.dart`** — Dual `ThemeData` (dark + light) using new color tokens. Both themes use `ThemeExtension`.
- [x] **Create `theme_provider.dart`** — Riverpod provider for theme mode (dark/light). Persist preference in Isar or SharedPreferences.
- [x] **Setup `ShellRoute` in `main.dart`** — Bottom navigation shell with 3 tabs: Play, History, Stats. Practice/Results/Settings as standalone push routes.
- [x] **Create `zen_bottom_nav.dart`** — Custom `BottomNavigationBar` with gold active indicator, custom icons, proper styling per RULES.md.
- [x] **Create persistent Header Bar** — Screen title (left) + Settings gear (right), transparent, no elevation.
- [x] **Create placeholder screens** — `HistoryScreen`, `StatsScreen`, `SettingsScreen` with proper scaffold and routing.
- [x] **Verify full navigation flow** — Tab switching, push routes (practice/results/settings), back navigation, deep linking.

---

## Phase 5: Design System Components (The Foundation Layer)
> **Goal:** Build every reusable widget to premium spec BEFORE building screens.
> **Priority:** P0 — Screens depend on these components.

- [x] **Overhaul `ZenCard`** — New decoration (hairline border dark / ambient shadow light), tap feedback (scale 0.97 + haptic), `AnimatedScale` on press.
- [x] **Create `ZenButton`** — Primary (gold pill), Secondary (outlined pill), Ghost variants. All with press feedback.
- [x] **Create `ZenProgressRing`** — `CustomPainter`-based circular progress. Gradient stroke (gold). Animated fill via `TweenAnimationBuilder`. Replace all `CircularProgressIndicator` usage.
- [x] **Overhaul `ZenNumPad`** — New styling per RULES.md. Scale(0.95) + color shift on press. Submit key in gold. Delete key with coral icon.
- [x] **Overhaul `ZenBottomSheet`** — Remove glassmorphism. Clean surface color, drag handle, proper radii (32px top corners), slide-up animation with strong ease-out.
- [x] **Create `ZenSegmentedControl`** — For difficulty selection (Easy/Medium/Hard) and stats period toggle (7d/30d).
- [x] **Overhaul `ZenScaffold`** — Theme-aware background color, proper safe area handling, integration with bottom nav shell.
- [x] **Create `animations.dart` utility** — Shared custom curves (`Cubic(0.23, 1.0, 0.32, 1.0)`), duration constants, reusable `PageRouteBuilder` transitions.
- [x] **Create `haptics.dart` utility** — Centralized haptic helpers: `ZenHaptics.light()`, `.medium()`, `.heavy()`, `.selection()`.
- [x] **Run Anti-Generic Checklist** on all components.

---

## Phase 6: Screen Redesign — Play (Home Dashboard)
> **Goal:** Completely redesign the home screen to premium spec.
> **Priority:** P0

- [x] **Contextual greeting** — "Good morning/afternoon/evening" based on time of day. `titleLarge` style.
- [x] **Stats row** — Streak ring (left, `ZenProgressRing`) + Level/XP card (right) in a `Row`.
- [x] **Streak ring** — Custom painted, gold gradient, large centered streak number with fire emoji. "Day Streak" label below.
- [x] **Level/XP section** — Current level number (display style), XP progress bar (linear, gold fill), "X / 500 XP" label.
- [x] **Featured action card** — "Timed Challenge" with timer icon, description, tap → practice with `isTimed: true`.
- [x] **Topics section** — "Topics" section header + 2-column `GridView` of topic cards.
- [x] **Topic cards** — Each with math symbol icon (gold) + topic name. Tap → difficulty bottom sheet.
- [x] **Staggered entrance animation** — Cards fade+slide in with 50ms stagger. Strong ease-out curve.
- [x] **Difficulty bottom sheet** — `ZenBottomSheet` with `ZenSegmentedControl` (Easy/Medium/Hard) + "Start" `ZenButton`.
- [x] **Run Anti-Generic Checklist.**

---

## Phase 7: Screen Redesign — Practice Arena & Results
> **Goal:** Polish the core practice flow to premium spec.
> **Priority:** P0

### Practice Arena
- [x] **Fullscreen mode** — No bottom nav, no header. Only close (X) top-left + progress top-center.
- [x] **Progress indicator** — Minimal: "3 / 10" text or thin linear progress bar (gold) at top.
- [x] **Question display** — MASSIVE 72px Outfit Bold, centered, with `AnimatedSwitcher` (scale+fade transition).
- [x] **User input display** — Below question, 48px, gold when typing, `textTertiary` when empty ("?").
- [x] **Feedback system** — Correct: surface glows `success` at 20% opacity, 300ms. Wrong: shake animation (spring physics, ±12px, 3 oscillations) + surface glows `error` at 20%.
- [x] **Timer display (timed mode)** — Centered top, large, color shifts to coral when <10s.
- [x] **Numpad** — Redesigned `ZenNumPad` at bottom third of screen.
- [x] **Custom page transition** — Entering practice = slide up from bottom (400ms, strong ease-out).

### Results Screen
- [x] **Fullscreen mode** — No bottom nav. "Session Complete" title.
- [x] **Accuracy ring** — Large `ZenProgressRing`, animated fill (1.2s), color-coded (green >80%, gold 50-80%, coral <50%).
- [x] **Score count-up** — `TweenAnimationBuilder` counting from 0 to score, 1s duration.
- [x] **XP gained display** — "+50 XP" with gold accent, animated entrance.
- [x] **Continue button** — `ZenButton` primary, "Continue" → navigates to Play tab.
- [x] **Staggered entrance** — All elements fade+slide in with 50ms stagger.

---

## Phase 8: New Screens — History & Stats
> **Goal:** Build the two new tab screens.
> **Priority:** P1

### History Screen
- [x] **Session list** — `ListView.builder` with session cards, grouped by date (Today, Yesterday, This Week, Earlier).
- [x] **Session card** — Topic icon + name, score (X/Y), accuracy %, date/time. Color accent based on accuracy.
- [x] **Empty state** — Illustration (or icon+text) + "Start your first session" with CTA button.
- [x] **Pull-to-refresh** — Refresh with spring physics, custom indicator (gold).
- [x] **Staggered entrance** — Cards animate in on first load.

### Stats Screen
- [x] **Period toggle** — `ZenSegmentedControl` for 7-day / 30-day / All Time.
- [x] **Growth chart** — `fl_chart` line chart, success color, in a `ZenCard`. Responsive to period toggle.
- [x] **Stats grid** — 2x2 grid: Total Sessions, Best Streak, Avg Accuracy, Total XP. Each in a mini `ZenCard`.
- [x] **Topic breakdown** — List of topics with mini horizontal progress bars showing performance per topic.
- [x] **Level section** — Current level, XP progress bar, total XP earned.
- [x] **Staggered entrance** — All sections animate in.

---

## Phase 9: Settings Screen & Theme Toggle
> **Goal:** Build the settings screen with theme switching.
> **Priority:** P1

- [x] **Settings screen structure** — Grouped list with section headers.
- [x] **Appearance section:**
  - [x] Theme toggle: Dark / Light mode switch (custom styled toggle or segmented control)
  - [x] Theme applies immediately via `theme_provider.dart`
  - [x] Preference persists across app restarts
- [x] **Practice section:**
  - [x] Default difficulty selector
  - [x] Default question count (10, 15, 20)
  - [x] Sound effects toggle (future)
- [x] **Feedback section:**
  - [x] Haptic feedback toggle (on/off)
  - [x] Animations toggle (reduced motion support)
- [x] **About section:**
  - [x] App version
  - [x] "Built with ❤️ by Akashiverse"
- [x] **Back navigation** — AppBar with back arrow, title "Settings".

---

## Phase 10: Polish & Delight (The Gold Layer)
> **Goal:** The invisible details that make it feel $150k.
> **Priority:** P2

- [x] **Custom page transitions** — `PageRouteBuilder` for all route transitions (slide up for practice, fade for tab content).
- [x] **Splash screen** — Soft fade-in of ZenMath wordmark, 1.5s, `Hero` transition to home.
- [x] **Loading states** — Shimmer/skeleton for async data (streak, XP, chart data).
- [x] **Error states** — Friendly error messages with retry CTA, not raw "Err" text.
- [x] **Empty states** — Thoughtful empty states for history (no sessions yet) and stats (no data yet).
- [x] **Pull-to-refresh** — Custom refresh indicator with gold accent.
- [x] **Scroll physics** — `BouncingScrollPhysics` everywhere for iOS-like feel.
- [x] **Edge-to-edge treatment** — Proper `SystemUiOverlayStyle` for status bar + nav bar theming.
- [x] **App icon** — Minimal ZenMath icon (gold accent on dark) for launcher.
- [x] **Review all animations at 2-5x speed** — Check for timing issues, sync problems.
- [x] **Performance audit** — 60fps check on real device, jank elimination, `RepaintBoundary` placement.
- [x] **Accessibility audit** — `Semantics` on all interactive elements, contrast ratios, font scaling.

---

## Phase 11+: Future Expansion (Backlog)
> **Priority:** P3 — After core redesign is complete and polished.

- [ ] Onboarding flow for first-time users (3 screens, staggered, premium)
- [ ] Achievement system with unlockable badges
- [ ] Daily challenge mode (1 challenge per day, specific topic+difficulty)
- [ ] Sound effects (subtle, toggleable)
- [ ] Practice history detail view (tap a history card → see question-by-question breakdown)
- [ ] Export stats (share as image)
- [ ] Widget for Android home screen (streak counter)
- [ ] Localization support (Hindi, etc.)
