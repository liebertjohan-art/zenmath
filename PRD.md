# ZenMath — Product Requirement Document (v2.1)

> **This PRD replaces v2.0.** Completed features have been removed to focus on ongoing development.
> Backups are available in the `ROADMAPS/` folder.

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
- **Current Version:** 2.0.0+1 → Target: **2.1.0+1**

---

## 2. Executive Summary

ZenMath v2 successfully overhauled the UI/UX, bringing a premium mobile experience with proper navigation, dark/light themes, smooth animations, and solid state management. 

**ZenMath v2.1 focuses on bug fixes, UI polish, and immediate feature enhancements.**
Key focus areas:
- Instant state updates across screens (e.g., Level, XP, Streak on Play page).
- Fixing broken UI components (e.g., Light theme Results screen).
- Enhancing the practice flow with auto-progression on correct answers.
- Refining feedback animations and highlights.

---

## 3. User Personas & User Stories

### Personas
- **The Self-Improver:** Wants daily mental math practice without kiddie aesthetics.
- **The Stats Lover:** Wants beautiful progress visualization and streak tracking.

### New User Stories (v2.1)
- As a user, I want my XP and Level to update instantly when I return to the home screen.
- As a user, I want the app to automatically proceed to the next question when I enter the right answer, reducing manual clicks.
- As a user, I want clear and non-intrusive feedback (horizontal highlight over my answer) when I get a question right or wrong.
- As a user, I want the report card to look flawless in both dark and light modes.

---

## 4. Current Issues & Enhancements

### 4.1 Bug Fixes
- **Play Page State Updates:** Level, XP, and Day Streak values lag or require a restart/reload to update properly. They must instantly reflect changes upon popping back from the Practice/Results screen.
- **Light Theme Results UI:** The report card center circle breaks layout in Light theme (content spills out). Needs responsive containment and proper styling to match the Dark theme's integrity.

### 4.2 Feature Enhancements
- **Auto-Go on Correct Answer:** In the Practice Arena, when a user types the correct answer, automatically submit and progress to the next step (or Results screen) without requiring a click on the Submit key.
- **Answer Highlight Rectangle Polish:** Replace the current vertical highlight rectangle for correct/wrong feedback. It should be a horizontal rectangle exclusively covering the answer text, making it cleaner and more elegant.

---

## 5. Technical Architecture Updates

- **State Management:** Ensure Riverpod providers (`streak_provider.dart`, `progress_provider.dart`) use `.autoDispose` or trigger manual refreshes (`ref.refresh()`) when returning to the Play screen.
- **UI Adjustments:** Modify `ZenProgressRing` or Results screen layout constraints in `app_theme.dart` to handle light theme rendering differences. Update `PracticeScreen` logic for auto-submit.

---

## 6. Release Plan

| Phase | Version | Scope |
| --- | --- | --- |
| Phase 11 | 2.1.0 | Bug Fixes & UI Improvements |
| Future | 2.x.x | Onboarding, Achievements, Daily Challenges |
