# ZenMath — Product Requirement Document (v2.0)

> **This PRD replaces v1.0.** All completed Phase 0–3 features are omitted.
> This document covers the redesign and all new features going forward.

---

## 1. Title & Metadata
- **App Name:** ZenMath
- **Package Name:** `com.akashiverse.zenmath`
- **Target Platform:** Android (phone-first, offline-only)
- **Flutter Version:** 3.44.0 (stable, cloud builds via GitHub Actions)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Local Storage:** Isar 3.x (offline-first, typed, fast)
- **Navigation:** go_router with `ShellRoute`
- **Fonts:** Outfit (display) + Plus Jakarta Sans (body) via `google_fonts`
- **Charts:** fl_chart
- **Current Version:** 1.0.0+1 → Will become **2.0.0+1** after redesign

---

## 2. Executive Summary

ZenMath v1 shipped a functional math practice app with 8 topics, difficulty levels, streak tracking, XP system, timed challenges, and progress charts. However, the UI lacks structural planning — no navigation system, no settings, no theme support, and the visual design feels unpolished and unstructured.

**ZenMath v2 is a complete UI/UX redesign** that transforms the app from a functional prototype into a premium, agency-quality mobile experience. The core practice logic stays. Everything else gets rebuilt.

### What's Changing:
| Area | v1 (Current) | v2 (Target) |
| --- | --- | --- |
| Navigation | No nav bar, single scroll page | Bottom nav (Play, History, Stats) + Settings push route |
| Theme | Dark only, hardcoded colors | Dark + Light themes, theme toggle, token-based system |
| Home Screen | Monolithic scroll with everything crammed in | Clean dashboard with greeting, streak ring, XP, topic grid |
| History | None | Full session history with grouping, filtering, empty states |
| Stats | Inline chart on home | Dedicated stats screen with period toggle, topic breakdown |
| Settings | None | Full settings screen (theme, haptics, defaults) |
| Components | Minimal custom widgets | Full design system (ZenCard, ZenButton, ZenProgressRing, ZenNumPad, ZenSegmentedControl) |
| Colors | Generic dark (#121212, #242623) | Richer palette (#0A0A0F, #14141F) with blue undertones |
| Motion | Basic stagger + shake | Purposeful motion system with custom curves, spring physics, press feedback |
| Accessibility | None | Semantics, contrast ratios, reduced motion, font scaling |

---

## 3. User Personas & User Stories

### Personas (unchanged from v1)
- **The Self-Improver:** Wants daily mental math practice without kiddie aesthetics
- **The Stats Lover:** Wants beautiful progress visualization and streak tracking

### New User Stories (v2)
- As a user, I want a **bottom navigation bar** so I can quickly switch between Practice, History, and Stats.
- As a user, I want a **settings screen** where I can toggle dark/light theme and control haptic feedback.
- As a user, I want to **see my session history** organized by date so I can review past performance.
- As a user, I want a **dedicated stats screen** with charts and breakdowns so I can understand my growth patterns.
- As a user, I want the app to **feel premium and polished** — smooth animations, haptic feedback, thoughtful empty states.
- As a user, I want to **switch between dark and light themes** based on my preference.
- As a user, I want **tap feedback on every button** so the interface feels responsive and alive.

---

## 4. Design Personality & Direction (LOCKED)

- **Direction Name:** Midnight Zen — Evolved
- **Personality:** Calm, Confident, Premium, Alive
- **Reference Mood:** Apple Fitness+ meets Headspace meets Linear
- **Color Strategy:** Deep blue-black backgrounds (not generic grey-black), warm gold accents, sage green for success, soft coral for errors
- **Typography Strategy:** Outfit for massive display numbers, Plus Jakarta Sans for everything else. Optical sizing (negative tracking on large text, positive on small).
- **Motion Strategy:** Purpose-driven animation. Custom ease-out curves (`Cubic(0.23, 1.0, 0.32, 1.0)`). Spring physics for gestures. 50ms stagger for lists. Every tap gets scale(0.97) + haptic feedback. Never ease-in.
- **Layout Strategy:** Structured dashboard with clear hierarchy. 2-column grid for topics. Stats row with ring + XP. Breathing room (32-48px section gaps). No clutter.

> **See `RULES.md` for the complete style bible with exact hex codes, spacing tokens, motion curves, and component specs.**

---

## 5. Screen-by-Screen Specification

### 5.1 Play Screen (Home Dashboard) — `/play`
**Purpose:** Primary hub — topic selection, streak overview, quick actions.
**State:** Default tab on app launch.

**Layout (top to bottom):**
1. **Header:** "ZenMath" title (left) + Settings gear icon (right)
2. **Greeting:** "Good morning/afternoon/evening" — contextual, `titleLarge`
3. **Stats Row:**
   - Left: Streak ring (`ZenProgressRing`) — custom painted, gold gradient, streak count centered, "Day Streak" label
   - Right: Level card — Level number (display), XP progress bar (linear, gold), "X / 500 XP"
4. **Featured Card:** "Timed Challenge" — icon + title + subtitle, tap → practice with `isTimed: true`
5. **Topics Section:** "Topics" header + 2-column grid of topic cards (8 topics: +, -, ×, ÷, %, ⅟, ., x)
6. **Bottom Nav:** Play (active), History, Stats

**Interactions:**
- Topic card tap → Difficulty bottom sheet
- Featured card tap → Practice (timed mode)
- Settings gear tap → push `/settings`
- Bottom nav tabs → switch screens

**Animations:**
- Staggered entrance for topic cards (fade+slide up, 50ms delay per card)
- Streak ring animated fill on screen load
- Topic card press: scale(0.97) + haptic

**State Variations:**
- Loading: Shimmer skeletons for streak/XP
- Error: Friendly message + retry
- First launch: Same layout but streak=0, level=1, XP=0

---

### 5.2 Practice Arena — `/practice`
**Purpose:** Core practice flow — the zen state.
**State:** Fullscreen, no bottom nav, no header.

**Layout:**
1. **Top bar:** Close (X) button (left), Progress "3/10" or timer (center)
2. **Question area:** Massive question text (72px, Outfit Bold), centered vertically in upper half
3. **Input area:** User's typed answer (48px, gold), below question
4. **Feedback zone:** Background glow overlay for correct (green) / wrong (coral)
5. **Numpad:** `ZenNumPad` in bottom third — 4-column grid, large keys

**Interactions:**
- Number key tap → append digit + `HapticFeedback.lightImpact()`
- Delete key tap → remove last digit + `HapticFeedback.lightImpact()`
- Submit key tap → evaluate answer
- Close (X) tap → pop back to Play tab

**Animations:**
- Question transition: `AnimatedSwitcher` with scale(0.95→1.0) + fade
- Correct answer: Surface glow green 20% opacity, 300ms ease-out, `HapticFeedback.mediumImpact()`
- Wrong answer: Shake ±12px (3 oscillations, spring decay, 400ms) + surface glow coral 20%, `HapticFeedback.heavyImpact()`
- Numpad key press: scale(0.95) + color shift to `surfaceBright`, 100ms
- Page entrance: Slide up from bottom, 400ms, strong ease-out

**State Variations:**
- Normal mode: "3 / 10" progress text
- Timed mode: Timer countdown (seconds), coral color when <10s
- Session end: Auto-navigate to Results

---

### 5.3 Results Screen — `/results`
**Purpose:** Post-session feedback and celebration.
**State:** Fullscreen, no bottom nav.

**Layout:**
1. **Title:** "Session Complete" — centered, `displayMedium`
2. **Accuracy Ring:** Large `ZenProgressRing` (180px diameter, 16px stroke), color-coded
3. **Percentage:** Inside ring, animated count-up "87%"
4. **Score:** "8 / 10 Correct" — `titleLarge`
5. **XP Gained:** "+50 XP" — gold accent
6. **Continue Button:** `ZenButton` primary (gold pill), "Continue" → Play tab

**Animations:**
- Staggered entrance: Each element fades+slides in with 50ms delay
- Accuracy ring: Animated fill 0→value, 1.2s, ease-out-cubic
- Score number: Count-up from 0, 1s, TweenAnimationBuilder
- XP: Delayed entrance (after ring completes), gold flash

**Color Coding:**
- ≥80%: Success green
- 50-79%: Gold
- <50%: Soft coral

---

### 5.4 History Screen — `/history`
**Purpose:** Review past practice sessions.
**State:** Second tab in bottom nav.

**Layout:**
1. **Header:** "History" title (left) + Settings gear (right)
2. **Session list:** Grouped by date (Today, Yesterday, This Week, Earlier)
3. **Session card:** Topic icon + Topic name + Score (X/Y) + Accuracy % + Date/time
4. **Group header:** Date group label, `labelSmall` uppercase

**Interactions:**
- Scroll through sessions (vertical list)
- Pull-to-refresh (reload from Isar)

**State Variations:**
- Empty: Icon + "No sessions yet" + "Start your first session" button → Play tab
- Loading: Shimmer skeletons
- Populated: Grouped list with staggered entrance

**Data Source:** Isar `SessionScore` collection, ordered by date descending.

---

### 5.5 Stats Screen — `/stats`
**Purpose:** Analytics dashboard — understand growth patterns.
**State:** Third tab in bottom nav.

**Layout:**
1. **Header:** "Statistics" title (left) + Settings gear (right)
2. **Period toggle:** `ZenSegmentedControl` — 7 Days / 30 Days / All Time
3. **Growth chart:** `fl_chart` line chart in a `ZenCard`, responsive to period
4. **Stats grid (2x2):**
   - Total Sessions (number)
   - Best Streak (number + "days")
   - Avg Accuracy (percentage)
   - Total XP (number)
5. **Topic Breakdown:** List of topics with horizontal progress bars (accuracy per topic)
6. **Level Section:** Current level, XP bar, total XP

**Interactions:**
- Period toggle switches chart data
- Scroll for more content

**State Variations:**
- Empty: "Complete your first session to see stats"
- Loading: Shimmer
- Populated: Full dashboard

---

### 5.6 Settings Screen — `/settings`
**Purpose:** App configuration and preferences.
**State:** Push route (not a tab), shows back button.

**Layout (grouped list):**

**Appearance:**
- Theme: Dark / Light toggle (custom switch or segmented control)

**Practice Defaults:**
- Default difficulty: Easy / Medium / Hard selector
- Questions per session: 10 / 15 / 20

**Feedback:**
- Haptic feedback: Toggle on/off
- Reduced motion: Toggle on/off (respects system setting as default)

**About:**
- Version: "ZenMath v2.0.0"
- Built by: "Akashiverse"

---

## 6. Component Library Spec

### Design Tokens
> Full spec in `RULES.md` Section 2-4. Summary below.

**Colors (Dark):**
- Background: `#0A0A0F` — Deep blue-black
- Surface: `#14141F` — Card backgrounds
- Primary: `#D4AF37` — Zen Gold (accent)
- Success: `#7EC9A0` — Bright sage
- Error: `#E07A5F` — Soft coral

**Colors (Light):**
- Background: `#F8F7F4` — Warm paper
- Surface: `#FFFFFF` — Clean white
- Primary: `#B8962E` — Deeper gold for contrast

**Typography:** Outfit (display) + Plus Jakarta Sans (body)
**Spacing:** 4pt base, 8pt rhythm: 4/8/12/16/20/24/32/48/64
**Radii:** 8/12/16/20/24/32/999 (pills)

### Custom Widgets
| Widget | Purpose |
| --- | --- |
| `ZenCard` | Themed card with tap feedback (scale+haptic) |
| `ZenButton` | Primary/Secondary/Ghost button variants |
| `ZenProgressRing` | CustomPainter circular progress with gradient |
| `ZenNumPad` | Custom numpad with styled keys |
| `ZenBottomSheet` | Styled modal bottom sheet |
| `ZenSegmentedControl` | Pill-style segmented toggle |
| `ZenScaffold` | Theme-aware app scaffold |

---

## 7. Non-Functional Requirements

### Performance
- **60fps minimum** (120fps target on high-refresh displays)
- Zero jank during practice arena transitions
- `const` constructors, `RepaintBoundary`, `AnimatedBuilder` over `setState`
- Lazy list rendering (`ListView.builder`)
- `BouncingScrollPhysics` on all scrollable surfaces

### Storage
- 100% offline via Isar
- Theme preference persisted locally
- No internet connection required at any point

### Haptics
- `HapticFeedback.lightImpact()` — numpad taps, button presses
- `HapticFeedback.mediumImpact()` — correct answer
- `HapticFeedback.heavyImpact()` — wrong answer
- `HapticFeedback.selectionClick()` — tab switch, toggle

### Accessibility
- `Semantics` on all interactive elements
- WCAG AA contrast ratios (4.5:1 body, 3:1 large text)
- System font scaling respected
- Reduced motion option (disable transform animations, keep fades)
- Minimum 48x48px tap targets

---

## 8. Technical Architecture

### State Management
- **Riverpod** (`flutter_riverpod`) for all state
- `theme_provider.dart` — Theme mode (StateNotifier)
- `streak_provider.dart` — Streak count (FutureProvider)
- `progress_provider.dart` — Session data, XP, weekly stats
- `db_provider.dart` — Isar instance

### Navigation
- **go_router** with `ShellRoute` for bottom nav
- Tab routes: `/play`, `/history`, `/stats`
- Push routes: `/practice`, `/results`, `/settings`
- Custom `PageRouteBuilder` transitions

### Local Storage
- **Isar** — `SessionScore`, `DailyProgress`, `TopicStats` schemas (existing)
- **SharedPreferences** (or Isar) — Theme preference, haptic toggle, default difficulty

### Package Dependencies (current + new)
```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  go_router: ^14.6.2
  google_fonts: ^6.2.1
  fl_chart: ^0.69.0
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.5
  shared_preferences: ^2.3.0  # NEW — for theme/settings persistence
```

---

## 9. Edge Cases & Risk Mitigation

| Risk | Mitigation |
| --- | --- |
| Theme switch causes layout jumps | Use `AnimatedTheme` or instant swap (per RULES.md — don't animate theme switch) |
| Isar schema migration (v1→v2) | Handle gracefully with Isar migration strategy; no data loss |
| Empty states (new install, no data) | Thoughtful empty states with CTA for every screen |
| Streak timezone issues | Normalize to local date, not UTC |
| Large history list performance | `ListView.builder` with lazy rendering, pagination if needed |
| Font loading delay | `google_fonts` caches after first load; show system font briefly if needed |
| Back button from results | Navigate to Play tab, not back to practice |

---

## 10. Success Metrics
- App feels premium on first launch (the "wow" factor)
- Navigation is intuitive — user finds Play, History, Stats within 2 seconds
- Theme toggle works instantly with no visual glitch
- Practice flow is smooth — zero dropped frames during question transitions
- User can review past sessions in History
- User can understand their growth in Stats

---

## 11. Release Plan

| Phase | Version | Scope |
| --- | --- | --- |
| Phase 4-5 | 2.0.0-alpha | Architecture + Design System |
| Phase 6-7 | 2.0.0-beta | Play + Practice + Results redesign |
| Phase 8-9 | 2.0.0-rc | History + Stats + Settings |
| Phase 10 | 2.0.0 | Polish + Release |
| Phase 11+ | 2.x.x | Future features |
