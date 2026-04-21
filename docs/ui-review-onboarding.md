# UI Review: Onboarding Flow
**App:** CalorieTracker  
**Reviewed:** April 17, 2026  
**Screens:** 5 screenshots (Steps 1–4 of onboarding)  
**Status:** First draft — pre Play Store launch

---

## Screens Covered

| Step | Screen | Description |
|------|--------|-------------|
| 1 of 3 | Personal Info | Full Name, Date of Birth (date picker), Gender selector |
| 2 of 3 | Activity Level | Radio card selector — Sedentary / Lightly Active / Moderately Active / Very Active |
| 3 of 3 | Your Goal | Goal selector (Lose / Maintain / Gain) + Gluten-Free Diet toggle |

---

## 🔴 Critical Bugs — Fix Before Launch

### BUG-ON-01 · Floating debug hamburger button visible on Steps 2, 3, 4

**Symptom:** A floating circular button with a `≡` (hamburger) icon appears on the left edge of the screen on the Body Metrics, Activity Level, and Your Goal screens. On Step 4 it partially overlaps and cuts off the "Gluten-Free Diet" label.

**Likely cause:** A debug overlay widget, drag handle, or developer tool that is not gated behind a debug-only build flag and is rendering in release/profile builds.

**Fix:**
- Locate the widget responsible for this floating button (likely a `FloatingActionButton`, `Overlay`, or debug scaffold widget).
- Wrap it in a debug-only guard:
  - Flutter: `if (kDebugMode) ...`
  - Android: `if (BuildConfig.DEBUG) ...`
- Verify it does not appear in a release build (`flutter run --release` or a signed APK).

---

### BUG-ON-02 · Date of Birth displays in raw ISO format (`1990-01-01`)

**Symptom:** After the user selects a date via the date picker on Step 1 (Personal Info), the Date of Birth field renders the raw ISO string `1990-01-01` instead of a human-readable date.

**Fix:**
- Before binding the selected date to the display field, format it using a date formatter.
- Flutter example:
  ```dart
  import 'package:intl/intl.dart';
  final formatted = DateFormat('MMMM d, yyyy').format(selectedDate);
  // renders: "January 1, 1990"
  ```
- Apply this fix everywhere DOB is displayed: the onboarding Step 1 field AND the Profile screen (see also BUG-DT-04).

---

## 🟡 UX Improvements — Strongly Recommended

---

### UX-ON-01 · Large empty whitespace on Steps 1 and 2

**Screen:** Step 1 (Personal Info), Step 2 (Body Metrics)  
**Issue:** Both screens have significant blank space below the input fields, making them feel incomplete.

**Recommended fix (pick one):**
- Add a short contextual tip below the fields, e.g. on Step 2: *"We use this to calculate your personalised daily calorie goal."*
- Add a subtle illustration or icon relevant to the step theme.
- Show a live preview, e.g. estimated BMR or calorie range based on current inputs.

---

### UX-ON-02 · Gluten-Free Diet toggle out of place on Step 4

**Screen:** Step 4 — Your Goal  
**Issue:** The Gluten-Free Diet toggle sits below the weight goal options (Lose / Maintain / Gain). Goal-setting and dietary preferences are different concerns and mixing them creates a cluttered final step.

**Recommended fix:**
- Move dietary preferences (Gluten-Free and any future diet types) to a dedicated section in the Profile / Settings screen, accessible after onboarding.
- For MVP: remove the toggle from onboarding entirely. The user can configure it in Profile later.

---

### UX-ON-03 · Missing Welcome / Splash screen before Step 1

**Issue:** The onboarding flow starts immediately at data entry with no brand moment. Most apps have a brief welcome screen before asking for personal information.

**Recommended fix:**
- Add a single pre-onboarding screen containing:
  - App logo + app name
  - Short tagline (e.g. *"Track smarter. Live healthier."*)
  - A single `Get Started` CTA button
- This screen should appear only on first launch, not on subsequent app opens.

---

### UX-ON-04 · Missing "Extra Active" fifth activity level (low priority)

**Screen:** Step 3 — Activity Level  
**Issue:** Standard calorie calculation formulas (Mifflin-St Jeor, Harris-Benedict) use 5 activity tiers. The app only shows 4. Missing: **Extra Active** — hard exercise every day or a physical job (athletes, construction workers).

**Recommended fix:**
- Add a fifth radio card: `Extra Active — Hard exercise every day or physical job`
- Update the calorie goal calculation multiplier for this tier (typically `× 1.9`).

---

## 🎨 Design & Branding Notes

### Color
The dark green theme is appropriate and consistent for a health/wellness app. Suggested Material Design anchors if standardising:
- **Primary (CTAs, selected states):** `#1B5E20` (Green 900)
- **Primary variant (progress bar, headings):** `#388E3C` (Green 700)
- **Surface light (card backgrounds):** `#E8F5E9` (Green 50)

### Typography
Current font appears to be the system default. For a more polished feel, consider a free Google Font:
- **Inter** — clean, modern, excellent at small sizes
- **Nunito** — friendly and rounded, approachable
- **DM Sans** — geometric, contemporary, works well for health apps

### Logo
No app logo is visible in the current onboarding screenshots. A logo is needed for:
- The Welcome / Splash screen (see UX-ON-04)
- The Play Store listing icon

Suggested logo directions:
- Leaf + simple bar chart or flame — communicates health + tracking
- Fork/plate + leaf element — universal food/health metaphor
- Keep it minimal and single-colour for Play Store icon legibility at small sizes

---

## ✅ Pre-Launch Checklist

| # | Action Item | Priority |
|---|-------------|----------|
| 1 | Fix floating `≡` debug button — remove from release builds (BUG-ON-01) | 🔴 Required |
| 2 | Fix Date of Birth display from ISO to human-readable format (BUG-ON-02) | 🔴 Required |
| 3 | Fill empty whitespace on Steps 1 & 2 with tip text or illustration (UX-ON-02) | 🟡 Recommended |
| 4 | Move Gluten-Free Diet toggle from onboarding to Profile / Settings (UX-ON-03) | 🟡 Recommended |
| 5 | Add Welcome / Splash screen before Step 1 (UX-ON-04) | 🟡 Recommended |
| 6 | Finalise app logo and add to splash screen and Play Store listing | 🟡 Recommended |
| 7 | Add "Extra Active" as a 5th activity level option (UX-ON-05) | ⚪ Optional |
| 8 | Confirm font choice and apply consistently across all screens | ⚪ Optional |

**Priority key:**
- 🔴 Required — must be fixed before Play Store submission
- 🟡 Recommended — strongly advised for quality and user trust
- ⚪ Optional — nice to have, can be done post-launch
