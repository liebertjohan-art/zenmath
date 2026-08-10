# ZenMath — Design Rules & Style Bible

> AI INSTRUCTION: Jab bhi tu confuse ho, jab bhi "default" use karne ka mann kare,
> jab bhi generic output aane lage — STOP. Ye file padh. Fir decide kar.
> Har 3-4 components ke baad ye file check kar.
> Generic = REJECTED. No exceptions.

## Design Direction: Midnight Zen Dashboard
## Design Personality: Calm, Confident, Focused

## Color Rules
- **Background:** `#121212` (Midnight Black) — App Scaffold background.
- **Surface:** `#242623` (Deep Slate) — Cards, Dialogs, Numpad buttons.
- **Primary:** `#D4AF37` (Zen Gold) — Active states, primary CTA, high-level achievements.
- **Success/Growth:** `#8BA888` (Sage Green) — Correct answers, upward trends, streak maintained.
- **Error/Alert:** `#E07A5F` (Soft Coral) — Wrong answers, streak at risk. NOT default red.
- **Text Primary:** `#EDEDED` (Off-White) — Headings, main numbers.
- **Text Secondary:** `#A0A0A0` (Muted Grey) — Subtitles, hints, inactive states.
- **BANNED COLORS:** Default Material Blue, generic Red (`Colors.red`), pure White (`Colors.white` for backgrounds), flat grey.

## Typography Rules
- **Display Font:** `Outfit` (Bold/Medium) — Use for massive numbers in practice mode, main screen titles, and scores.
- **Body Font:** `Plus Jakarta Sans` (Regular/Medium) — Use for labels, buttons, and subtext.
- **Size Scale:** 12 (hint) / 14 (body) / 16 (button) / 20 (subtitle) / 28 (title) / 48+ (practice numbers).
- **RULE:** Minimum contrast ratio between heading and body = 3:1 size difference. 
- **RULE:** Never use default system font. EVER.

## Spacing Rules
- **Base unit:** 8pt.
- **Scale:** 8 / 16 / 24 / 32 / 48 / 64.
- **RULE:** No random padding values. Always use the scale (e.g., `padding: EdgeInsets.all(16)`).
- **RULE:** Vertical spacing between sections must be large (e.g., 32pt or 48pt) to let the design breathe.

## Motion & Interaction Rules
- **Default curve:** `Curves.easeOutCubic` (smooth deceleration).
- **Duration scale:** micro (150ms for button taps), medium (400ms for bottom sheets), large (600ms for screen transitions).
- **RULE:** Every state change must animate. No instant layout snaps. (Use `AnimatedSwitcher` for changing text/numbers).
- **RULE:** Entrance animations must use stagger (e.g., cards on home screen fade in sequentially).
- **RULE:** Interactive elements (cards, numpad) MUST have tap feedback (subtle scale down or color shift) + Haptics.

## Component Rules
- **Cards (`ZenCard`):** Corner radius `24px`. Background `#242623`. Subtle inner border or soft outer shadow. NO default `Card()` elevation.
- **Numpad (`ZenNumPad`):** Large hit areas. Minimalist look (no heavy borders). Haptic feedback on every tap.
- **Bottom Sheets:** Glassmorphism effect (`BackdropFilter` with blur `10.0`), top rounded corners `32px`.
- **App Bar:** Transparent, no drop shadow. Text left-aligned with ample top padding.

## Anti-Generic Checklist (Run Every 3-4 Components)
- [ ] Am I using any default Material colors? → REPLACE with ZenColors.
- [ ] Am I using any unstyled widgets (like raw `Text()` without Theme)? → CUSTOMIZE.
- [ ] Is there at least one animation/transition on this screen? → ADD `AnimatedContainer` or `Hero`.
- [ ] Does this look like a boring math homework app? → REDESIGN, add soul.
- [ ] Does this have personality? → ADD SOUL (haptics, smooth curves, premium spacing).

## When In Doubt Protocol
1. STOP writing code.
2. Remember the vibe: **Apple Fitness+ meets Headspace**.
3. Ask: "Is this calm, confident, and premium?"
4. If NO → redesign before continuing.
