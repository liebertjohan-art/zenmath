# ZenMath — Product Requirement Document

## 1. Title & Metadata
- **App Name:** ZenMath
- **Package Name:** `com.akashiverse.zenmath`
- **Target Platform:** Android (Phone-first, offline)
- **Tech Stack:** Flutter 3.44.0 (stable), Riverpod (State Management), Isar (Local Storage), GitHub Actions (CI/CD cloud builds).

## 2. Executive Summary & Problem Statement
Most math practice apps are either targeted at children (cartoony, loud) or feel like generic, boring calculators. **ZenMath** bridges this gap by offering a daily math practice tool for adults/students that feels like a premium, peaceful habit-building app. It focuses on basic arithmetic but tracks progress meticulously without overwhelming the user. Fully offline, private, and beautifully designed.

## 3. User Personas & User Stories
- **The Self-Improver:** "I want to sharpen my mental math skills daily without feeling like I'm playing a kid's game."
- **The Stats Lover:** "I want to see my growth over time through clean, visually appealing graphs and streak counters."
- **User Stories:**
  - As a user, I want to select a math topic (e.g., Addition) and practice at my difficulty level.
  - As a user, I want instant, non-intrusive feedback on my answers.
  - As a user, I want to see a summary of my session and track my daily streak.

## 4. Design Personality & Direction (LOCKED)
- **Name:** Midnight Zen Dashboard
- **Personality:** Calm, Confident, Focused. (Headspace meets Apple Fitness+)
- **Vibe:** A zen garden mapped onto a sleek modern dashboard. Dark mode primary, warm accent colors. No default Material blue, no generic list views.

## 5. Screen-by-Screen Specification
- **Splash / Boot Screen:**
  - *Purpose:* App launch transition.
  - *Design:* Soft fade-in of the ZenMath logo, minimalist loading indicator.
  - *Animations:* `Hero` transition to Home Screen.
- **Home Screen (The Zen Dashboard):**
  - *Purpose:* Topic selection and daily progress overview.
  - *Key Widgets:* 
    - Custom Streak Ring (Apple Fitness+ style).
    - Asymmetric staggered grid for Topic Cards (Addition, Subtraction, etc.).
  - *Animations:* Staggered fade-in/slide-up for cards (`staggered_animations`).
- **Practice Configuration (BottomSheet/Dialog):**
  - *Purpose:* Choose difficulty before starting.
  - *Design:* Glassmorphism bottom sheet (`BackdropFilter`). Segmented control for Easy/Medium/Hard.
- **Practice Arena (The Flow State):**
  - *Purpose:* Core practice loop.
  - *Key Widgets:* Massive typography for the current question. Custom numpad (no default keyboard). 
  - *Animations:* Subtle shake on wrong answer, soft glow/haptic on correct answer. Fluid number transitions (`AnimatedSwitcher`).
- **Session Results:**
  - *Purpose:* Feedback after a session.
  - *Design:* Minimalist score card, accuracy ring, XP/streak update.
  - *Animations:* Numbers counting up smoothly (`TweenAnimationBuilder`).

## 6. Component Library Spec
- **Design Tokens:**
  - *Primary:* `#D4AF37` (Zen Gold)
  - *Background:* `#121212` (Midnight Black)
  - *Surface:* `#242623` (Deep Slate)
  - *Success/Growth:* `#8BA888` (Sage Green)
  - *Error/Alert:* `#E07A5F` (Soft Coral)
- **Typography:** `Outfit` for display numbers (bold, geometric), `Plus Jakarta Sans` for UI/body text.
- **Custom Widgets:** `ZenCard`, `ZenNumPad`, `StatRing`, `GlassBottomSheet`.

## 7. Non-Functional Requirements
- **Performance:** 60fps/120fps lock. Zero jank during practice arena transitions.
- **Storage:** 100% offline via Isar. No internet connection required.
- **Haptics:** Thoughtful `HapticFeedback` on numpad taps and answer evaluations.

## 8. Technical Architecture
- **State Management:** Riverpod (`flutter_riverpod`). Clean separation of UI and business logic.
- **Local Storage:** Isar Database (extremely fast, typed, perfect for offline stats tracking).
- **Navigation:** `go_router` for declarative routing and shell routes.

## 9. Edge Cases & Risk Mitigation
- **Streak Logic:** Handling timezone changes for daily streaks.
- **App Updates:** Since it's offline and installed via APK, database schema migrations (Isar) need to be handled gracefully in the future.

## 10. Success Metrics
- Average session length.
- App retention (measured by user's daily streak).

## 11. Release Plan
- **Phase 1 (MVP):** Core 4 topics, basic difficulty, session score, local storage.
- **Phase 2 (Growth):** Streak system, progress graphs, level up mechanics.
- **Phase 3 (Expansion):** More topics (percentages, fractions), timed challenges.
