# Enhancements — Calorie Tracker

Captured: 2026-04-19  
Status legend: `[ ]` open · `[x]` done

---

## ENH-01 · Add Morning Snack and Evening Snack meal sections

**Priority:** High  
**Area:** Dashboard · Food Log

**Description:**  
The dashboard currently shows Breakfast, Lunch, Dinner, and Snacks. Two dedicated
snack slots are needed:

- **Morning Snack** — displayed after Breakfast, before Lunch  
- **Evening Snack** — displayed after Lunch, before Dinner  

The existing "Snacks" section can remain as a catch-all or be renamed "Night Snack"
depending on preference.

**Scope:**
- Add `morning_snack` and `evening_snack` as valid `mealType` values everywhere
  meal type is used: `food_logs` DAO, `MealSection` widget, dashboard provider,
  food search screen tab list, and history screen.
- Update the dashboard meal order: Breakfast → Morning Snack → Lunch →
  Evening Snack → Dinner → Snacks.
- Ensure calorie totals still aggregate all meal types correctly.

---

## ENH-02 · Burned calories not reflected immediately after logging exercise

**Priority:** High  
**Area:** Exercise Log · Dashboard

**Description:**  
After logging an exercise the dashboard calorie ring / net-calorie figure does not
update until the screen is reloaded or navigated away and back. Burned calories
should reflect in real time the moment the exercise is saved.

**Likely cause:**  
The dashboard `StreamProvider` may not be watching the `exercise_logs` stream, or
the exercise log provider completes the insert but does not trigger a stream
re-emission that the dashboard is subscribed to.

**Scope:**
- Trace the reactive chain: `ExerciseLogsDao` insert → stream → dashboard provider.
- Confirm the dashboard provider aggregates burned calories from the same date-scoped
  stream as food logs.
- Fix any missing `watch` / broken stream subscription so the update is instant
  without any manual refresh.

---

## ENH-03 · Dashboard top-right icon — add useful action

**Priority:** Medium  
**Area:** Dashboard

**Description:**  
The top-right icon on the Dashboard AppBar is currently a no-op (tapping it does
nothing). Replace it with a useful action. Suggested options (pick one):

1. **Nutrition summary sheet** — bottom sheet showing today's macro breakdown
   (protein / carbs / fat) as a percentage of targets, plus a meal-by-meal calorie
   split.
2. **Quick-log shortcut** — opens the food search screen directly without having
   to scroll to a meal section first.
3. **Share / export day** — copies a plain-text summary of the day's intake to the
   clipboard.

Recommended: option 1 (Nutrition summary sheet) — it surfaces data already on screen
in a richer format and requires no navigation.

**Scope:**
- Wire `onPressed` on the AppBar action icon.
- Implement the chosen action (bottom sheet preferred).
- Icon should reflect the action (e.g. `Icons.bar_chart_outlined` for summary).

---

## ENH-04 · Delete individual logged exercise entries not working

**Priority:** High  
**Area:** Exercise Log · Dashboard

**Description:**  
Tapping the delete icon on an individual exercise log row on the dashboard has no
effect — the entry remains. The delete action is either not wired up, the wrong ID
is being passed, or the DAO call is not completing successfully.

**Scope:**
- Check the delete icon's `onTap` / `onPressed` handler in `ExerciseCard` or the
  exercise log tile.
- Verify the correct `log.id` is passed to `ExerciseLogsDao.deleteLog(id)`.
- Confirm the DAO emits a fresh stream after deletion so the UI updates reactively.
- Add a brief confirmation snackbar ("Exercise deleted") after successful removal,
  consistent with how food log deletions are handled.

---

## ENH-05 · Allow food logging on past dates

**Priority:** High  
**Area:** Food Log · Dashboard Date Navigation

**Description:**  
When navigating to a past date on the dashboard and tapping a meal section's add
button, the food search screen either defaults back to today or refuses to log to
the selected date. Users must be able to log food against any past date they can
navigate to.

**Scope:**
- The selected dashboard date is already held in `DashboardDateNotifier`. Ensure
  this date is passed all the way through to `FoodSearchScreen` → food detail →
  `FoodLogProvider.logFood()` and written into the `FoodLogsCompanion.date` field.
- Remove any guard that clamps the log date to today.
- The date displayed in the food detail / log confirmation should show the actual
  target date, not today's date.

---

## ENH-06 · Food search screen pre-selects correct meal tab

**Priority:** High  
**Area:** Food Log · Dashboard

**Description:**  
When the user taps "Add food" under a specific meal section (e.g. Lunch or Dinner),
the food search screen always opens with the **Breakfast** tab selected, forcing an
extra tap to switch to the intended meal. The tab that was tapped on the dashboard
should be pre-selected when the food search screen opens.

**Scope:**
- The `mealType` argument is already passed in the route arguments
  (`{'mealType': meal, 'date': date}`). Confirm it is read correctly in
  `FoodSearchScreen` and used to set the initial tab index.
- Map `mealType` string → tab index in `FoodSearchScreen`'s `initState` so the
  `TabController` starts on the right tab.
- Verify the selected tab is also forwarded to the food detail / log step so the
  final logged entry carries the correct `mealType`.

---
