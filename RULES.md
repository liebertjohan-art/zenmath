# ZenMath — Design Rules & Style Bible (v2.0)

> **AI INSTRUCTION:** Jab bhi tu confuse ho, jab bhi "default" use karne ka mann kare,
> jab bhi generic output aane lage — STOP. Ye file padh. Fir decide kar.
> Har 3-4 components ke baad ye file check kar.
> Generic = REJECTED. No exceptions.
>
> **"Kill the generic, kill the generic, kill the generic."**
> **"Generic style is like a curse, acting without a taste is a waste."**

---

## Design Direction: Midnight Zen — Evolved
## Design Personality: Calm, Confident, Premium, Alive
## Design Reference: Apple Fitness+ meets Headspace meets Linear
## Platform Target: Android (phone-first, cross-platform premium neutral)

---

## 1. App Architecture & Navigation

### Shell Navigation (MANDATORY)
The app MUST use `ShellRoute` (go_router) with a persistent bottom navigation bar.

```
┌──────────────────────────────────┐
│  [Header Bar]                    │
│  Left: App Logo / Screen Title   │
│  Right: Settings Gear Icon       │
├──────────────────────────────────┤
│                                  │
│  [Screen Content Area]           │
│  (Changes per tab)               │
│                                  │
│                                  │
├──────────────────────────────────┤
│  [Bottom Navigation Bar]         │
│  Play  │  History  │  Stats      │
│   🎯   │    📋     │    📊      │
└──────────────────────────────────┘
```

**3 Primary Tabs:**
| Tab | Icon | Purpose | Route |
| --- | --- | --- | --- |
| **Play** | Custom play/target icon | Topic selection, streak, quick actions | `/play` (home) |
| **History** | Custom clock/list icon | Session history, past performance | `/history` |
| **Stats** | Custom chart icon | Weekly/monthly stats, XP, achievements | `/stats` |

**Header Bar (Persistent across all tabs):**
- Left side: Screen title (contextual per tab — "ZenMath", "History", "Statistics")
- Right side: Settings gear icon → opens Settings screen (push route, NOT a tab)
- Transparent background, no elevation, no drop shadow
- Must respect safe areas

**Non-tab routes (push on top of shell):**
- `/practice` — Practice Arena (fullscreen, no bottom nav)
- `/results` — Session Results (fullscreen, no bottom nav)
- `/settings` — Settings Screen (push route, back button)

### Screen Hierarchy
```
ShellRoute (with BottomNav)
├── /play (PlayScreen — Home Dashboard)
├── /history (HistoryScreen — Session Log)
└── /stats (StatsScreen — Analytics Dashboard)

Standalone Routes (no BottomNav):
├── /practice (PracticeScreen — Fullscreen flow state)
├── /results (ResultsScreen — Post-session)
└── /settings (SettingsScreen — App configuration)
```

---

## 2. Theming System (Dark + Light)

### Theme Architecture
The app MUST support **Dark Mode** and **Light Mode** with a toggle in Settings.

Use `ThemeExtension<ZenDesignTokens>` for custom design tokens beyond Material's `ColorScheme`.

Store theme preference in Isar (or SharedPreferences) so it persists across sessions.

### Dark Theme — "Midnight Zen" (DEFAULT)

| Token | Hex | Usage |
| --- | --- | --- |
| `background` | `#0A0A0F` | Scaffold, full-screen backgrounds. NOT `#121212` — deeper, richer black with blue undertone. |
| `surface` | `#14141F` | Primary cards, elevated containers. |
| `surfaceVariant` | `#1E1E2D` | Secondary surfaces, input fields, numpad buttons. |
| `surfaceBright` | `#28283A` | Hover/pressed states on surfaces, active elements. |
| `primary` | `#D4AF37` | Zen Gold — CTAs, active states, high-priority actions. Use SPARINGLY. |
| `primaryMuted` | `#B8962E` | Gold at 85% — secondary gold elements, borders. |
| `primarySubtle` | `#D4AF37` @ 12% opacity | Gold glow backgrounds, tinted containers. |
| `success` | `#7EC9A0` | Correct answers, positive trends, streak maintained. Brighter than old sage. |
| `successMuted` | `#8BA888` | Secondary success elements, chart fills. |
| `error` | `#E07A5F` | Soft Coral — wrong answers, streak at risk. NOT default red. |
| `errorMuted` | `#E07A5F` @ 15% opacity | Error backgrounds, tinted states. |
| `textPrimary` | `#F0F0F5` | Headings, primary numbers, critical labels. |
| `textSecondary` | `#8888A0` | Subtitles, hints, inactive labels. More blue than grey. |
| `textTertiary` | `#555570` | Disabled text, placeholder states. |
| `divider` | `#FFFFFF` @ 6% | Hairline dividers, subtle borders. |
| `navBarSurface` | `#0F0F18` | Bottom nav background with subtle border-top. |

### Light Theme — "Paper Zen"

| Token | Hex | Usage |
| --- | --- | --- |
| `background` | `#F8F7F4` | Warm off-white. NOT pure white. Paper-like warmth. |
| `surface` | `#FFFFFF` | Cards, elevated containers. |
| `surfaceVariant` | `#F0EFE9` | Secondary surfaces, input fields. |
| `surfaceBright` | `#E8E7E1` | Pressed states on surfaces. |
| `primary` | `#B8962E` | Slightly deeper gold for contrast on light. |
| `primaryMuted` | `#D4AF37` | Lighter gold for secondary elements. |
| `success` | `#4A8C6A` | Deeper green for contrast on light backgrounds. |
| `error` | `#C9604A` | Deeper coral for readability. |
| `textPrimary` | `#1A1A24` | Near-black with blue undertone. |
| `textSecondary` | `#6B6B80` | Muted with same undertone as dark theme. |
| `textTertiary` | `#A0A0B0` | Disabled/placeholder. |
| `divider` | `#000000` @ 6% | Hairline dividers. |
| `navBarSurface` | `#FFFFFF` | Clean white nav with top border. |

### BANNED COLORS (Both Themes)
- `Colors.blue`, `Colors.red`, `Colors.green` — NO default Material colors
- `Colors.white` as background — ALWAYS use token
- `Colors.grey` — ALWAYS use `textSecondary` or `textTertiary`
- `Color(0xFF121212)` — OLD background, too generic. Use `#0A0A0F`
- `Color(0xFF242623)` — OLD surface, too green. Use `#14141F`
- Any unnamed hex inline in widget code — MUST use token reference

### Shadow System

**Dark theme:** Shadows are nearly invisible. Use inner highlights and border glows instead.
```dart
// Dark card decoration
BoxDecoration(
  color: ZenColors.surface,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.5),
  boxShadow: [
    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 8)),
  ],
)
```

**Light theme:** Multi-layer soft ambient shadows.
```dart
// Light card decoration
BoxDecoration(
  color: ZenColors.surface,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 24, offset: Offset(0, 8)),
  ],
)
```

---

## 3. Typography Rules

### Font Stack
- **Display Font:** `Outfit` (Bold/SemiBold) — Large numbers, screen titles, hero text
- **Body Font:** `Plus Jakarta Sans` (Regular/Medium/SemiBold) — UI labels, body, buttons
- **Mono Font (optional):** `JetBrains Mono` — If ever showing code or precise numbers in stats

### Type Scale (8pt baseline aligned)

| Role | Font | Size | Weight | Letter Spacing | Line Height | Usage |
| --- | --- | --- | --- | --- | --- | --- |
| `displayHero` | Outfit | 72px | Bold | -0.03em | 1.0 | Practice arena numbers |
| `displayLarge` | Outfit | 48px | Bold | -0.02em | 1.05 | Result percentages, big stats |
| `displayMedium` | Outfit | 36px | SemiBold | -0.015em | 1.1 | Screen hero titles |
| `titleLarge` | Outfit | 24px | SemiBold | -0.01em | 1.2 | Section headers |
| `titleMedium` | Plus Jakarta Sans | 18px | SemiBold | 0 | 1.3 | Card titles, nav labels |
| `bodyLarge` | Plus Jakarta Sans | 16px | Regular | 0 | 1.5 | Primary body text |
| `bodyMedium` | Plus Jakarta Sans | 14px | Regular | 0.005em | 1.5 | Secondary body text |
| `labelLarge` | Plus Jakarta Sans | 14px | SemiBold | 0.02em | 1.2 | Button text, tab labels |
| `labelSmall` | Plus Jakarta Sans | 11px | Medium | 0.04em | 1.3 | Eyebrow tags, captions, hints |

### Typography Rules
- **Minimum contrast ratio between heading and body = 3:1 size difference**
- **NEVER use default system font. EVER.**
- **Large text (>28px) gets NEGATIVE letter-spacing** (tighter tracking — Kowalski/Apple rule)
- **Small text (<14px) gets POSITIVE letter-spacing** (wider tracking for legibility)
- **Line height is inversely proportional to size** — tight on display, looser on body
- **Weight creates hierarchy, not just size** — use weight + size as a pair
- **Practice arena numbers must be MASSIVE (72px+)** — the number IS the screen

---

## 4. Spacing System

### Base Unit: 4pt (with 8pt as primary rhythm)

| Token | Value | Usage |
| --- | --- | --- |
| `xxs` | 4px | Icon-to-label gaps, hairline spacing |
| `xs` | 8px | Tight internal padding, inline gaps |
| `sm` | 12px | Small component padding |
| `md` | 16px | Standard internal padding |
| `lg` | 20px | Card internal padding |
| `xl` | 24px | Section horizontal padding (screen edges) |
| `xxl` | 32px | Major vertical section gaps |
| `xxxl` | 48px | Hero spacing, breathing room |
| `huge` | 64px | Screen-level vertical separation |

### Spacing Rules
- **Screen horizontal padding: 24px** — consistent across all screens
- **Vertical spacing between sections: 32px minimum** — let the design BREATHE
- **Card internal padding: 20px** — generous, not cramped
- **No random padding values** — ALWAYS use the token scale
- **Bottom nav height: 64px + safe area** — comfortable tap targets
- **Vertical > Horizontal** — section gaps must always exceed side padding
- **Grid gap for topic cards: 16px** — consistent gutter

### Corner Radius Scale

| Token | Value | Usage |
| --- | --- | --- |
| `xs` | 8px | Small chips, tags, pills |
| `sm` | 12px | Buttons, small inputs |
| `md` | 16px | Standard cards, numpad keys |
| `lg` | 20px | Primary cards, containers |
| `xl` | 24px | Featured cards, hero containers |
| `xxl` | 32px | Bottom sheets (top corners only) |
| `full` | 999px | Pill buttons, circular elements |

---

## 5. Motion & Animation Rules

### Core Philosophy (from Kowalski + Apple Design)
> "Every animation must have a clear purpose. 'It looks cool' is NOT a purpose for frequently-seen elements."
> "Think of animation as a conversation between you and the object."

### Animation Decision Tree
Before adding ANY animation, answer:
1. **How often will the user see this?** (100+/day = NO animation)
2. **What is the purpose?** (Feedback / Spatial consistency / State indication / Preventing jarring change)
3. **Can't name a purpose? DON'T ANIMATE.**

### Easing Curves

| Situation | Curve | Flutter Equivalent |
| --- | --- | --- |
| Element entering | `ease-out` | `Cubic(0.23, 1.0, 0.32, 1.0)` — Strong ease-out |
| Element exiting | `ease-out` (faster) | Same curve, 30% shorter duration |
| Moving/morphing on screen | `ease-in-out` | `Cubic(0.77, 0.0, 0.175, 1.0)` — Strong ease-in-out |
| State change (color, opacity) | `ease` | `Curves.easeOutCubic` |
| Spring/bounce (drag, flick) | Spring | `SpringSimulation` with damping 1.0, response 0.4 |
| **DEFAULT** | `ease-out` | `Cubic(0.23, 1.0, 0.32, 1.0)` |

### **NEVER use `ease-in` for UI.** It starts slow = feels sluggish. `ease-out` at 200ms feels faster than `ease-in` at 200ms.

### Duration Scale

| Element | Duration | Notes |
| --- | --- | --- |
| Button press/tap feedback | 100–150ms | Scale(0.97) on press — instant feedback |
| Numpad key press | 100ms | Light, snappy |
| Tooltip/small popup | 150ms | Quick appear |
| Bottom sheet open | 350ms | Smooth entrance |
| Bottom sheet close | 250ms | Exit 30% faster than enter |
| Screen transition | 400ms | Custom `PageRouteBuilder` |
| Stagger delay between items | 50ms | Per item in entrance sequence |
| Practice number transition | 200ms | `AnimatedSwitcher` with scale+fade |
| Feedback glow (correct/wrong) | 300ms | `AnimatedContainer` |

### **UI animations stay under 400ms.** 180ms dropdown > 400ms dropdown.

### Entrance Animation Rules
- **Stagger is MANDATORY for lists/grids** — 50ms delay between items
- **Never animate from scale(0)** — start from scale(0.95) + opacity(0)
- **Exit animations are 30% faster than entrance**
- **Fade + slide up (8-16px) for card entrances** — not just fade
- **Practice arena question transition:** `AnimatedSwitcher` with custom `SlideTransition` + `FadeTransition`

### Interaction Feedback Rules
- **Every tappable element MUST have feedback:**
  - Scale down to 0.97 on press (not 0.95 — too much)
  - Subtle color shift or highlight on tap
  - `HapticFeedback.lightImpact()` on numpad taps
  - `HapticFeedback.mediumImpact()` on correct answer
  - `HapticFeedback.heavyImpact()` on wrong answer (with shake)
- **Shake animation for wrong answer:** Horizontal offset ±12px, 3 oscillations, 400ms total, spring-like decay
- **Correct answer:** Soft glow pulse (success color at 30% opacity → 0%), 500ms

### What NOT to Animate
- Theme switching animation (instant swap is fine — it's a settings action)
- Tab switching in bottom nav (content swaps instantly, indicator animates)
- Keyboard-initiated actions (if we ever add keyboard shortcuts)

---

## 6. Component Design Rules

### Cards (`ZenCard`)
- Corner radius: `20px` (lg token)
- Background: `surface` color token
- Border: `0.5px` white at 4% opacity (dark) / none (light, use shadow)
- Shadow: See Shadow System in Section 2
- Internal padding: `20px`
- **NO default `Card()` widget** — always custom `Container` with `BoxDecoration`
- **NO default elevation** — custom shadows only
- Tap feedback: Scale(0.97) + haptic

### Topic Cards (Home Grid)
- 2-column grid layout using `GridView` or `Wrap`
- Each card: Icon (mathematical symbol) + Topic name
- Icon: 28px, gold color (primary token), left-aligned
- Title: `titleMedium`, below icon with 8px gap
- Subtle indicator for "last practiced" or "new topic"
- Staggered entrance animation (50ms per card)

### Numpad (`ZenNumPad`)
- 4-column grid: [1-9, 0, delete, submit]
- Large hit areas: minimum 64x64px per key
- Key background: `surfaceVariant` token
- Key corner radius: `16px`
- Key press: Scale(0.95) + `surfaceBright` color + `HapticFeedback.lightImpact()`
- Submit button: Gold background (`primary`), larger visual weight
- Delete button: Soft coral icon, no background fill
- **No heavy borders** — minimalist, flat with subtle depth

### Bottom Navigation Bar
- Height: 64px + bottom safe area
- Background: `navBarSurface` token
- Top border: `divider` token (hairline)
- **NO blur/glass effect on nav** — clean solid background
- Active tab: Gold icon + gold label, slight scale(1.05) on icon
- Inactive tab: `textTertiary` color
- Icon size: 24px
- Label size: `labelSmall` (11px)
- Tab indicator: Small gold dot (4px) below active icon, animated with spring
- Transition between tabs: Indicator slides with `Cubic(0.23, 1.0, 0.32, 1.0)`, 250ms

### Bottom Sheets (Difficulty Selection, etc.)
- Top corners: `32px` radius
- Drag handle: 40px wide, 4px tall, `textTertiary` color, centered
- Background: `surface` color (NOT glassmorphism — that was overused)
- Subtle top shadow for depth
- Content padding: 24px horizontal, 16px top (below handle), 32px bottom
- Entrance: Slide up from bottom, 350ms, strong ease-out
- Exit: Slide down, 250ms

### App Bar / Header
- Transparent background, NO elevation, NO drop shadow
- Title: Left-aligned, `titleLarge` style
- Right action: Settings gear icon, `textSecondary` color, tap → push `/settings`
- Height: Standard AppBar height + status bar
- `scrolledUnderElevation: 0` — NO shadow on scroll

### Buttons
- Primary (gold): `primary` background, `background` text, `full` radius (pill), 56px height
- Secondary: Transparent background, `primary` border (1px), `primary` text, `full` radius
- Ghost: No border, `textSecondary` text, padding only
- All buttons: Scale(0.97) on press + haptic + 150ms ease-out transition

### Progress Rings (Streak, Accuracy)
- Custom painted with `CustomPainter` — NOT `CircularProgressIndicator`
- Ring width: 10px for large (streak), 6px for small (accuracy)
- Background ring: `surfaceVariant` token
- Active ring: Gradient from `primary` to `primaryMuted` (gold gradient)
- Round stroke cap
- Animated fill with `TweenAnimationBuilder`, 1.2s, ease-out-cubic

### Charts (fl_chart)
- Line chart: 2px stroke, `success` color, rounded
- Area fill: `success` at 15% opacity, gradient to transparent
- Grid: Hidden
- Axes: Hidden (minimal aesthetic)
- Dot data: Hidden
- Touch data: Optional tooltip on tap
- Container: `surface` card with standard card styling

### Settings Screen
- Grouped list with section headers
- Section header: `labelSmall` style, uppercase, `textTertiary` color
- List tiles: `surface` background, `divider` between items
- Toggle switches: Custom styled, `primary` color when active
- **Theme toggle: Dark/Light with current mode indicated**
- Sections: Appearance, Practice, Feedback (haptics/sound), About

---

## 7. Screen-Specific Rules

### Play Screen (Home Dashboard)
```
┌──────────────────────────────────┐
│ ZenMath                    ⚙️    │  ← Header
├──────────────────────────────────┤
│                                  │
│  Good [morning/afternoon/evening]│  ← Contextual greeting
│                                  │
│  ┌─────────┐  ┌──────────────┐  │
│  │ Streak  │  │  Level & XP  │  │  ← Stats row
│  │  Ring   │  │  Progress    │  │
│  └─────────┘  └──────────────┘  │
│                                  │
│  ┌──────────────────────────┐   │
│  │  ⏱️ Timed Challenge      │   │  ← Featured action card
│  │  60s. Mixed. Go.         │   │
│  └──────────────────────────┘   │
│                                  │
│  Topics                          │  ← Section header
│  ┌────────┐  ┌────────┐        │
│  │  +     │  │  -     │        │  ← 2x4 grid (scrollable)
│  │ Add    │  │ Sub    │        │
│  └────────┘  └────────┘        │
│  ┌────────┐  ┌────────┐        │
│  │  ×     │  │  ÷     │        │
│  │ Mul    │  │ Div    │        │
│  └────────┘  └────────┘        │
│                                  │
├──────────────────────────────────┤
│  🎯 Play   │ 📋 History │ 📊 Stats │
└──────────────────────────────────┘
```

### Practice Arena
- Fullscreen — NO bottom nav, NO header
- Only: Close (X) button top-left, Progress indicator top-center
- Question: MASSIVE typography (72px), centered
- User input: Below question, gold color, 48px
- Numpad: Bottom third of screen
- Feedback: Background glow (green/coral) on answer submit
- Shake animation on wrong answer (spring physics)
- `AnimatedSwitcher` for question transitions

### Results Screen
- Fullscreen — NO bottom nav
- Centered layout
- Large accuracy ring (custom painted)
- Score count with `TweenAnimationBuilder` (counting up animation)
- "Continue" button → returns to Play tab
- Staggered entrance for all elements (50ms delay)

### History Screen
- Scrollable list of past sessions
- Each session card: Topic icon, Topic name, Score (X/Y), Accuracy %, Date
- Color-coded: Green accent for >80%, Gold for 50-80%, Coral for <50%
- Empty state: Illustration + "Start your first session" CTA
- Grouped by date (Today, Yesterday, This Week, etc.)

### Stats Screen
- 7-day / 30-day toggle (segmented control)
- Weekly growth chart (fl_chart)
- Stats grid: Total Sessions, Best Streak, Avg Accuracy, Total XP
- Topic breakdown: Performance per topic (mini progress bars)
- Level progress bar with XP

---

## 8. Accessibility Rules

- **`Semantics` widget on ALL interactive elements** — screen reader support
- **Minimum tap target: 48x48px** — Material guidelines
- **Contrast ratio: 4.5:1 minimum** for body text, 3:1 for large text (WCAG AA)
- **`prefers-reduced-motion` equivalent:** Provide option in Settings to disable animations
- **Font scaling:** Respect system text scale factor (use `MediaQuery.textScaleFactorOf`)
- **Focus management:** Logical tab order through numpad keys
- **Color is NEVER the only indicator** — always pair with icon/text/shape

---

## 9. Performance Rules

- **60fps minimum, 120fps target** — zero jank
- **`const` constructors everywhere possible** — widget rebuild optimization
- **`RepaintBoundary` around animated elements** — isolate repaints
- **`AnimatedBuilder` over `setState` for animations** — avoid full widget rebuilds
- **`BouncingScrollPhysics` for all scroll views** — iOS-like feel
- **Lazy loading for history list** — `ListView.builder`, not `ListView`
- **Image/font caching** — `google_fonts` handles this, but verify
- **No `Timer.periodic` for animations** — use `AnimationController` + `Ticker`

---

## 10. File & Code Organization

```
lib/
├── main.dart                          # App entry + router config
├── core/
│   ├── theme/
│   │   ├── app_theme.dart             # ThemeData (dark + light)
│   │   ├── zen_colors.dart            # Color tokens (dark + light palettes)
│   │   ├── zen_spacing.dart           # Spacing + Radii tokens
│   │   ├── zen_typography.dart        # TextStyle definitions
│   │   └── zen_design_tokens.dart     # ThemeExtension<ZenDesignTokens>
│   ├── widgets/
│   │   ├── zen_card.dart              # Reusable card with tap feedback
│   │   ├── zen_numpad.dart            # Custom numpad widget
│   │   ├── zen_button.dart            # Primary/Secondary/Ghost buttons
│   │   ├── zen_progress_ring.dart     # Custom painted circular progress
│   │   ├── zen_bottom_sheet.dart      # Styled bottom sheet
│   │   └── zen_scaffold.dart          # App-level scaffold wrapper
│   └── utils/
│       ├── haptics.dart               # Haptic feedback helpers
│       └── animations.dart            # Shared curves, durations, transitions
├── features/
│   ├── play/
│   │   └── play_screen.dart           # Home dashboard (was home_screen.dart)
│   ├── practice/
│   │   └── practice_screen.dart       # Practice arena
│   ├── results/
│   │   └── results_screen.dart        # Post-session results
│   ├── history/
│   │   └── history_screen.dart        # Session history list
│   ├── stats/
│   │   └── stats_screen.dart          # Analytics dashboard
│   └── settings/
│       └── settings_screen.dart       # App settings
├── data/
│   ├── models/                        # Isar schemas
│   └── isar_service.dart              # Database service
└── providers/                         # Riverpod providers
    ├── db_provider.dart
    ├── progress_provider.dart
    ├── streak_provider.dart
    └── theme_provider.dart            # Theme mode (dark/light) provider
```

---

## 11. Anti-Generic Checklist (MANDATORY — Run Every 3-4 Components)

- [ ] Am I using any default Material colors? → **REPLACE with ZenColors token**
- [ ] Am I using any unstyled widgets (raw `Text()`, `Card()`, `CircularProgressIndicator()`)? → **CUSTOMIZE**
- [ ] Is there at least one animation/transition on this screen? → **ADD purposeful motion**
- [ ] Am I using `Color(0xFF......)` inline? → **EXTRACT to ZenColors**
- [ ] Am I using `EdgeInsets` with non-token values? → **USE ZenSpacing tokens**
- [ ] Am I using `BorderRadius.circular()` with non-token values? → **USE ZenRadii tokens**
- [ ] Does this look like every other Flutter math app? → **REDESIGN, add soul**
- [ ] Would a designer save this on Dribbble? → If NO, **REDO**
- [ ] Does this have personality or is it soulless? → **ADD SOUL** (haptics, curves, spacing)
- [ ] Am I using `ease-in` anywhere? → **REPLACE with ease-out or custom curve**
- [ ] Am I animating from `scale(0)`? → **START from scale(0.95) + opacity(0)**
- [ ] Does every tappable element have press feedback? → **ADD scale(0.97) + haptic**
- [ ] Is there a bottom navigation bar visible? → If not on practice/results, **ADD IT**

---

## 12. The Default Tax

Every time you use a default/unstyled Flutter widget, you pay the "Default Tax" — you MUST immediately customize it:
- `AppBar()` without custom styling? **TAXED.**
- `Card()` without custom decoration? **TAXED.**
- `CircularProgressIndicator()` without custom colors? **TAXED.**
- `ElevatedButton()` without custom shape/color? **TAXED.**
- `Scaffold()` without theme-aware background? **TAXED.**
- `BottomNavigationBar()` without custom styling? **TAXED.**
- `ListTile()` without custom layout? **Consider custom Row/Column.**

---

## 13. When In Doubt Protocol

1. **STOP writing code.**
2. Re-read this file's Design Direction: **Midnight Zen — Evolved**
3. Re-read the Design Personality: **Calm, Confident, Premium, Alive**
4. Remember the reference: **Apple Fitness+ meets Headspace meets Linear**
5. Ask: "Is this calm, confident, and premium?"
6. Ask: "Would this survive an Awwwards mobile review?"
7. Ask: "Does this feel like a $150k agency build?"
8. If NO to ANY → **Redesign before continuing.**
9. If YES → Continue but stay vigilant.
10. Remember: **"Kill the generic. Kill the generic. Kill the generic."**
