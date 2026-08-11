# ZenMath — Development Roadmap (v2.2)

> **Previous Phases 0–11 are COMPLETE and archived in ROADMAPS/ROADMAP_1.md.**
> This roadmap focuses on a major UI/UX overhaul to kill the generic feel and implement sleek, modern, anti-generic design principles.

---

## 🚨 ROADMAP ARCHIVE RULE
> **Rule:** If there are more than 10 phases, and further phases represent separate tasks that have no connection to old phases, once the current phases are done, archive the current `ROADMAP.md` to the `ROADMAPS` folder by incrementing the last available number by 1 (e.g., `ROADMAP_2.md`).

---

## Phase 12: Premium UI Overhaul & Anti-Generic Polish
> **Goal:** Remove bulky shadows, implement sleek modern UI, add glassmorphism, and refine animations.
> **Priority:** P0

### Sub-tasks for Phase 12:
- [ ] **Global Design System Polish:**
  - Remove bulky shadows from cards. Transition to a flatter, sleek, modern look with very subtle ambient shadows or borders.
  - Improve section dividers (cleaner, subtle).
  - Update Light Theme colors to use soft white, natural blue/light blue, and Material You dynamic colors if available.
  - Ensure the Session Complete / Results page uses satisfying green accents.
- [ ] **Pill Bottom Navigation:**
  - Redesign bottom navigation to be a floating "pill" style.
  - Reserve space at the bottom so content (lists/grids) doesn't scroll *underneath* the pill and get hidden, but the pill floats above the reserved space.
  - Implement animation: When pushing to a new page (e.g., practice), the pill expands/merges into the page. On back, it morphs back to a pill.
- [ ] **Topic Cards & Glassmorphism Menu:**
  - Redesign topic cards for a sleeker look.
  - When clicking a topic card, the difficulty menu must appear using a premium glassmorphism (blur) effect (`BackdropFilter`).
- [ ] **Animations & Scrolling:**
  - Ensure smooth scrolling globally (`BouncingScrollPhysics` or tight physics).
  - Add brutal, clean page transition animations (no crazy/bouncy animations, just sharp, elegant curves).

---

## Future Expansions (Backlog)
> **Priority:** P3 — After core bug fixes and UI polish are complete.

- [ ] Onboarding flow for first-time users (3 screens, staggered, premium)
- [ ] Achievement system with unlockable badges
- [ ] Daily challenge mode (1 challenge per day, specific topic+difficulty)
- [ ] Sound effects (subtle, toggleable)
- [ ] Export stats (share as image)
- [ ] Widget for Android home screen (streak counter)
