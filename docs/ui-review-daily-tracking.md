# UI Review: Daily Tracking Screens
**App:** CalorieTracker  
**Reviewed:** April 17, 2026  
**Screenshots:** 21 screenshots across all core daily-use screens  
**Status:** First draft — pre Play Store launch

---

## Screens Covered

| # | Screen | What Was Reviewed |
|---|--------|-------------------|
| 1 | Dashboard — Empty state | Calorie ring (0/2228 kcal), macro bars, meal sections, Log Food FAB, bottom nav |
| 2 | Dashboard — Meal expanded | Breakfast expanded: "No foods logged yet." + "+ Add to Breakfast" |
| 3 | Dashboard — Food logged | Ring, macro bars, and meal items updated with totals after logging |
| 4 | Food Search | Search bar, GF Only toggle, food list with letter avatars and kcal/100g |
| 5 | Food Detail | Gluten badge, serving size input, nutrition table, meal selector, Log Food CTA |
| 6 | Add Custom Food | Form: name, brand, category, gluten status, macros per 100g, default serving |
| 7 | Category Dropdown | Full list: Grains, Dairy, Meat, Fish, Vegetables, Fruits, Legumes, Nuts, etc. |
| 8 | Gluten Status Dropdown | Options: Unknown / Gluten Free / Contains Gluten / May Contain Gluten |
| 9 | History | Past day view with date arrows, calorie ring, per-meal breakdown |
| 10 | Weight Trend — Empty | Empty state with "Log at least 2 entries to see your trend." |
| 11 | Weight Trend — With data | Area chart, 2 weight entries, history list |
| 12 | Profile | Editable: name, DOB, gender, height, weight, activity level, goal, water target |

---

## 🔴 Critical Bugs — Fix Before Launch

### BUG-DT-01 · Food names display as "Food #XX" on Dashboard after logging

**Symptom:** After logging food items to a meal, the Dashboard shows entries as `Food #32`, `Food #192`, `Food #322`, `Food #2` instead of their actual names (e.g. "Ragi Dosa", "Chai with milk and sugar", "Basmati Rice (cooked)"). The Food Detail screen correctly shows the name before logging, but the name is lost once the item is added to the meal log.

**This is the most critical bug in the app.** It makes every logged meal completely unreadable.

**Likely cause:**
- The food log entry model is storing only the food database ID (e.g. `32`, `192`, `322`) and not the food name.
- The Dashboard meal list widget is rendering the ID directly (e.g. `"Food #${entry.foodId}"`) instead of resolving the food name from the database.

**Fix:**
- Option A (recommended): When creating a log entry, store the food name alongside the ID in the log entry model: `{ foodId: 32, foodName: "Ragi Dosa", ... }`. This avoids a database join on every render.
- Option B: When rendering the Dashboard meal list, perform a lookup: fetch the food name from the food database using the stored `foodId` and display it.
- After fixing, verify that existing logged entries (if any) are also updated or migrated correctly.

---

### BUG-DT-02 · Floating debug `≡` button on Food Search and Weight Trend screens

**Symptom:** Same floating circular `≡` hamburger button reported in onboarding (BUG-ON-01) also appears on:
- Food Search screen (Add to Breakfast / Add to Lunch)
- Food Search results screen
- Weight Trend screen

**Fix:** Same fix as BUG-ON-01 — gate the widget behind a debug-only build flag and verify it is absent in release builds. This is likely the same widget instance; fixing it once in the root scaffold or overlay stack should resolve it across all screens.

---

### BUG-DT-03 · Exercise row shows "−0 kcal" in History screen

**Symptom:** The Exercise section in the History screen displays `−0 kcal` when no exercise has been logged. The negative zero is a sign inversion bug: the app correctly treats burned calories as negative (to subtract from net), but does not guard against applying the negative sign when the value is zero.

**Fix:**
```dart
// Before rendering the exercise calories label:
String formatExerciseKcal(int burned) {
  if (burned == 0) return '0 kcal';
  return '−${burned} kcal';
}
```
Alternatively, hide the Exercise row entirely in History when `burned == 0`.

---

### BUG-DT-04 · Date of Birth in ISO format on Profile screen

**Symptom:** The Date of Birth field on the Profile screen displays `1990-01-01` in raw ISO format.

**Fix:** Apply the same date formatting fix as BUG-ON-02. Use a shared date formatter utility so this is consistent across the entire app:
```dart
import 'package:intl/intl.dart';
final formatted = DateFormat('MMMM d, yyyy').format(dob);
// renders: "January 1, 1990"
```

---

### BUG-DT-05 · History screen date displayed in ISO format

**Symptom:** The date navigation header in the History screen shows `2026-04-17` in raw ISO format. The Dashboard shows `Fri, Apr 17` in a friendly format — these are inconsistent.

**Fix:** Apply the same date formatter to the History screen date header:
```dart
final formatted = DateFormat('EEE, MMM d').format(historyDate);
// renders: "Fri, Apr 17"
```

---

## 🟡 UX Improvements — Strongly Recommended

### UX-DT-01 · Serving size unit is hardcoded to grams on all foods

**Screen:** Food Detail, Add Custom Food  
**Issue:** The serving size field only allows `g` (grams) as a unit. For beverages like Chai, `ml` is more natural. For items like eggs or fruit, `piece` or `unit` is more intuitive. Forcing grams for everything creates friction and may cause users to enter incorrect values.

**Recommended fix:**
- Add a unit dropdown next to the serving size input field with options: `g`, `ml`, `oz`, `cup`, `piece / unit`
- The selected unit should be pre-populated from the food's `defaultServingUnit` field.
- When displaying the serving description (e.g. "1 medium dosa", "1 katori cooked"), show it as hint text next to the input — this is already done and works well.
- Store the unit alongside the serving quantity in the food log entry.

---

### UX-DT-02 · No date navigation on Dashboard — cannot log food for past dates

**Screen:** Dashboard  
**Issue:** The Dashboard header shows `Fri, Apr 17` as a static label with no way to navigate to previous days. Users regularly need to log food they forgot to add earlier. The History tab is read-only and does not support food logging for past dates.

**Recommended fix:**
- Add `<` and `>` arrow buttons flanking the date label on the Dashboard header (same pattern already implemented on the History screen).
- Tapping `<` moves to the previous day; `>` returns toward today (disable `>` when already on today).
- The selected date should persist as the active logging date for all "+ Add to [Meal]" actions until the user navigates back to today.

---

### UX-DT-03 · Exercise section has no visible "Add" entry point

**Screen:** Dashboard — Exercise section  
**Issue:** The Exercise section shows "No exercise logged yet." but has no `+ Log Exercise` button, unlike every meal section which shows `+ Add to Breakfast` / `+ Add to Lunch` etc. It is not discoverable how to log exercise from the Dashboard.

**Recommended fix (pick one):**
- Option A: Add a `+ Log Exercise` text link inside the Exercise section, consistent with the `+ Add to [Meal]` pattern used by all meal sections.
- Option B: Expand the `+ Log Food` FAB into a speed dial (mini FAB) with two options: `Log Food` and `Log Exercise`.

---

### UX-DT-04 · Auto-calculate Calories from macros in Add Custom Food form

**Screen:** Add Custom Food  
**Issue:** The form asks for Calories (kcal) as a separate input alongside Protein, Carbs, and Fat. If the user has filled in macro values, the calorie total can be derived automatically using the Atwater factors: `(Protein × 4) + (Carbs × 4) + (Fat × 9)`. Requiring the user to calculate and re-enter this is error-prone and creates duplicate work.

**Recommended fix:**
- Listen for changes on the Protein, Carbs, and Fat fields.
- When all three are filled, auto-populate the Calories field: `calories = (protein * 4) + (carbs * 4) + (fat * 9)`.
- Display a small `Auto-calculated` label or info icon next to the Calories field.
- Allow the user to manually override the auto-calculated value if their source data differs.

---



### UX-DT-06 · Weight Trend chart uses red — signals "bad" regardless of goal

**Screen:** Weight Trend  
**Issue:** The weight area chart uses a red line and red-tinted fill. Red universally signals danger or a problem. For a user whose goal is "Lose Weight", a downward trend is positive — but the red chart makes it look alarming.

**Recommended fix:**
- Make the chart color goal-aware:
  - User goal = **Lose Weight**: downward trend → green, upward trend → red
  - User goal = **Gain Weight**: upward trend → green, downward trend → red
  - User goal = **Maintain Weight**: chart in neutral blue or green
- Simpler MVP fix: default the chart to the app's primary green (`#1B5E20`) regardless of direction.

---

### UX-DT-07 · "Last 2 entries" section label on Weight Trend is dynamic and awkward

**Screen:** Weight Trend — history list  
**Issue:** The label "Last 2 entries" is dynamic (the number updates as entries are added). This becomes grammatically incorrect at 1 entry ("Last 1 entries") and verbose at many entries ("Last 47 entries").

**Fix:** Replace with a static label: **"Weight Log"** or **"Recent Entries"**.

---

### UX-DT-08 · Activity Level labels on Profile screen are truncated and inconsistent with Onboarding

**Screen:** Profile  
**Issue:** The Profile screen uses compact text buttons — "Sedentary", "Light", "Moderate", "Very Active" — which differ from the onboarding labels "Sedentary", "Lightly Active", "Moderately Active", "Very Active". The card-style radio buttons with descriptive sub-labels from onboarding are replaced with plain pill buttons on Profile.

**Fix:**
- Use the full label names consistently: "Lightly Active", "Moderately Active".
- Ideally use the same card-style radio component from onboarding, or a dropdown that opens the same cards. Reusing the component maintains design consistency and reduces code duplication.

---

## 🎨 Design & Consistency Notes

| Note | Detail |
|------|--------|
| **Calorie ring colour progression** | Consider changing the ring fill colour as the user approaches their limit: green below 75%, amber at 75–99%, red at 100%+. Gives an at-a-glance warning. |
| **Macro bar readability** | The three macro progress bars are thin and their labels are small. Slightly increasing bar height and label font size would improve scannability. |
| **Food list letter avatars** | Letter avatars (e.g. "B" for Basmati Rice) work but feel generic. Category icons (grain, beverage, vegetable) would be more informative and visually distinct. |
| **Dashboard vs History distinction** | Both screens look nearly identical. A subtle visual cue on History — e.g. a muted date banner, different header background — would signal "you are viewing a past record". |
| **Net calories tooltip** | "Consumed / Burned / Net" may confuse first-time users. A small ℹ️ icon that reveals a tooltip "Net = Consumed − Burned" on tap would help without cluttering the UI. |
| **Consistent Add entry points** | Meal sections use "+ Add to Breakfast" links. Exercise section has no add link. Standardise all "add" entry points to a single consistent pattern across all sections. |

---

## ✅ Pre-Launch Checklist

| # | Action Item | Priority |
|---|-------------|----------|
| 1 | Fix food names showing as "Food #XX" on Dashboard — display actual food names (BUG-DT-01) | 🔴 Required |
| 2 | Fix floating `≡` debug button on Food Search and Weight Trend screens (BUG-DT-02) | 🔴 Required |
| 3 | Fix Exercise showing "−0 kcal" in History — show "0 kcal" or hide when zero (BUG-DT-03) | 🔴 Required |
| 4 | Fix Date of Birth ISO format on Profile screen (BUG-DT-04) | 🔴 Required |
| 5 | Fix History date header from ISO format to friendly format (BUG-DT-05) | 🔴 Required |
| 6 | Add serving unit selector (g / ml / oz / piece) to Food Detail and Add Custom Food (UX-DT-01) | 🟡 Recommended |
| 7 | Add date navigation arrows to Dashboard header for past-date logging (UX-DT-02) | 🟡 Recommended |
| 8 | Add "+ Log Exercise" entry point inside the Exercise section on Dashboard (UX-DT-03) | 🟡 Recommended |
| 9 | Auto-calculate Calories from Protein/Carbs/Fat in Add Custom Food form (UX-DT-04) | 🟡 Recommended |
| 11 | Change Weight Trend chart colour to green or implement goal-aware colouring (UX-DT-06) | 🟡 Recommended |
| 12 | Replace "Last 2 entries" with static label "Weight Log" on Weight Trend screen (UX-DT-07) | ⚪ Optional |
| 13 | Align Activity Level labels on Profile with Onboarding — full names + card style (UX-DT-08) | ⚪ Optional |
| 14 | Add calorie ring colour progression (green → amber → red) as user approaches daily limit | ⚪ Optional |
| 15 | Add ℹ️ tooltip to "Net" calories label explaining Consumed − Burned | ⚪ Optional |

**Priority key:**
- 🔴 Required — must be fixed before Play Store submission
- 🟡 Recommended — strongly advised for quality and user trust
- ⚪ Optional — nice to have, can be done post-launch
