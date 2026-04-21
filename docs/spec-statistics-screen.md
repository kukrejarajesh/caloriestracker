# Feature Spec: Statistics Screen (v1)
**App:** CalorieTracker  
**Feature ID:** SPEC-002  
**Author:** Product Review  
**Date:** April 20, 2026  
**Status:** Draft — approved for implementation  
**Mockup:** `docs/statistics-screen-mockup.html`

---

## Problem Statement

The current app has a **History tab** in the bottom navigation that shows a day-by-day view of past food logs. This screen is redundant — the same navigation is already available by swiping dates on the Dashboard. The History tab occupies a prime bottom-nav slot but adds no analytical value.

Meanwhile, users who have been logging for a week or more have **no way to see whether their efforts are actually working**. They can see today's calories but cannot answer questions like: *"Am I consistently hitting my target?"*, *"Which macro am I consistently missing?"*, or *"How many days in a row have I logged?"* This lack of feedback is a key driver of early drop-off in calorie-tracking apps.

The Statistics screen replaces the History tab with a meaningful, motivating analytics view that answers these questions at a glance.

---

## Goals

1. **Replace the redundant History tab** with a Statistics tab that occupies the same slot in the bottom navigation.
2. **Give users a clear picture of their weekly and monthly calorie performance** through a bar chart with a goal target line.
3. **Surface macro consistency insights** so users understand not just whether they hit calories, but how their protein/carbs/fat split compares to their target.
4. **Motivate consistent daily logging** through a streak counter and days-on-target summary.
5. **Ship a focused, polished v1** — four components only — that can be delivered without delaying the Play Store launch.

---

## Non-Goals

- **No weight/BMI trend chart** in this screen — the Weight tab handles that separately.
- **No heatmap calendar** (GitHub-style logging consistency view) — deferred to v2.
- **No milestones or achievement badges** — deferred to v2.
- **No meal-level breakdown** (average calories per meal slot) — deferred to v2.
- **No "most logged foods" list** — deferred to v2.
- **No push notifications or nudges** triggered by Statistics data — separate feature.
- **No export or share functionality** for charts — out of scope for MVP.

---

## Navigation Change

### Current bottom nav (4 tabs)
`Dashboard | History | Weight | Profile`

### New bottom nav (4 tabs)
`Dashboard | Statistics | Weight | Profile`

- The **History** tab is removed entirely.
- **Statistics** takes its position (second tab, index 1).
- The **Weight** and **Profile** tabs are unchanged.
- Date-based history navigation remains available on the Dashboard via the `< Fri, Apr 17 >` date arrows (see UX-DT-02 in `ui-review-daily-tracking.md`).
- The Statistics tab icon: a bar chart icon (📊 or equivalent from the app's icon set).

---

## Screen Layout

The screen is a **vertically scrollable card feed** with a fixed header.

```
┌─────────────────────────────────┐
│  [Status bar]                   │
│  Statistics          [green bg] │
│  [ 7D ]  14D   30D              │
├─────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐    │  ← Row 1
│  │ 🔥 5     │  │ 🎯 5/7   │    │
│  │ Day      │  │ Days on  │    │
│  │ streak   │  │ target   │    │
│  └──────────┘  └──────────┘    │
│  ┌───────────────────────────┐  │  ← Card 2
│  │ Daily Calories            │  │
│  │ [bar chart with target]   │  │
│  │ ⌀ Avg: 2,024 kcal/day    │  │
│  └───────────────────────────┘  │
│  ┌───────────────────────────┐  │  ← Card 3
│  │ Average Macro Split       │  │
│  │ [donut]  Protein  68g 28% │  │
│  │          Carbs   121g 48% │  │
│  │          Fat      54g 24% │  │
│  └───────────────────────────┘  │
└─────────────────────────────────┘
```

---

## Component Specifications

### Component 1 — Period Toggle (Header)

**Location:** Inside the green app header, below the "Statistics" title.  
**Options:** `7D` · `14D` · `30D`  
**Default:** `7D` (7 days)  
**Behaviour:**
- Selecting a period updates all four components simultaneously.
- The active period button has a white background with green text; inactive buttons show white text at reduced opacity.
- The selected period is **not persisted** between sessions — always opens at 7D.

---

### Component 2 — Streak & Days on Target (Side-by-Side Cards)

Two equal-width cards displayed in a horizontal row.

#### 2a — Logging Streak Card

| Element | Spec |
|---------|------|
| Icon | 🔥 fire emoji, 22px |
| Primary value | Integer — number of consecutive days with at least one food item logged |
| Label | "Day streak" |
| Secondary line | "Personal best: X days" — shows the user's all-time longest streak |
| Value colour | `#1B5E20` (primary green) |

**Streak definition:** A streak increments by 1 for each calendar day on which the user logs at least one food entry. A streak resets to 0 if the user does not log anything on a calendar day. The streak is calculated in the user's local timezone.

**Edge cases:**
- If the user has never logged before: show `0` with label "Start logging today!"
- If today has not been logged yet: streak shows yesterday's streak value (does not reset until midnight passes without a log entry).

#### 2b — Days on Target Card

| Element | Spec |
|---------|------|
| Icon | 🎯 target emoji, 22px |
| Primary value | Fraction: `X / Y` where X = days on target, Y = days logged in the period |
| Label | "Days on target" |
| 7D indicator | Seven dot indicators (Mon–Sun). Each dot: green = on target, red = off target, grey = not logged |
| 14D/30D indicator | Replace dots with a horizontal progress bar: green fill = % on target, label below (e.g. "70% on target") |
| Value colour | `#1B5E20` |

**"On target" definition:** A day is considered "on target" if the user's net calories for that day are within ±10% of their daily calorie target.

- Example: Daily target = 2178 kcal. On-target range = 1960–2396 kcal.
- Days with no log entries are excluded from both X and Y (not counted as off-target).

---

### Component 3 — Daily Calorie Bar Chart

**Card title:** "Daily Calories"

#### Chart layout

| Element | Spec |
|---------|------|
| Chart type | Vertical bar chart |
| Height | 110px (chart area) |
| Bar width | Equal width, fills available space; minimum 6px gap between bars |
| Bar count | 7 bars (7D), 14 bars (14D), 30 bars (30D) |
| X-axis labels | 7D: 3-letter day abbreviations (Mon, Tue…). 14D: show every other label. 30D: show no labels (bars are narrow; labels would overlap) |
| Y-axis | No explicit axis lines; bars speak for themselves |
| Target line | Horizontal dashed red line (`#E53935`, 1.5px, dashed) drawn at the user's daily calorie target value. Label "XXXX" shown at the right end of the line |

#### Bar colour logic

| Condition | Colour | Label |
|-----------|--------|-------|
| Net kcal ≤ 102% of target | `#388E3C` Green | On target |
| Net kcal 103%–110% of target | `#FF9800` Amber | Slightly over |
| Net kcal > 110% of target | `#E53935` Red | Over goal |
| Net kcal < 85% of target | `#90CAF9` Light blue | Under |
| Day not logged | `#E0E0E0` Grey | No data |

**Bar value label:** Show the calorie value above each bar as a small label (e.g. "2.1k" for 2,100 kcal). For the 30D view, omit value labels (too crowded at narrow bar widths).

**Not-logged bars:** Show as a short grey stub (4px height) to indicate the day exists but has no data. Do not show a value label.

#### Below the chart

- **Legend:** Four colour chips with labels: On target · Slightly over · Over goal · Under
- **Average pill:** Centred below the legend. Format: `⌀ Avg: X,XXX kcal/day`. Calculated as the mean of all logged days in the period (excluding unlogged days from the average).

---

### Component 4 — Average Macro Split Donut Chart

**Card title:** "Average Macro Split · [7 Days / 14 Days / 30 Days]" — updates with period toggle.

#### Donut chart

| Element | Spec |
|---------|------|
| Chart type | Donut (ring) chart |
| Size | 90×90px |
| Ring width | ~4px stroke |
| Segments | 3: Protein · Carbs · Fat |
| Segment colours | Protein: `#1565C0` (blue) · Carbs: `#FF8F00` (amber) · Fat: `#E53935` (red) |
| Centre text | Line 1: Average daily kcal (e.g. "2,024"). Line 2: "avg kcal" in grey |
| Rotation | Chart starts from 12 o'clock (top), rotates clockwise |
| Segment order | Protein → Carbs → Fat (clockwise) |

**Calculation:** For each nutrient, calculate the simple average grams per day across all logged days in the period. Derive percentage from total average kcal:
```
protein_pct  = (avg_protein_g  × 4) / avg_kcal × 100
carbs_pct    = (avg_carbs_g    × 4) / avg_kcal × 100
fat_pct      = (avg_fat_g      × 9) / avg_kcal × 100
```

#### Macro legend (right of donut)

For each macro, show:
- Colour chip (10×10px, rounded square)
- Macro name (Protein / Carbs / Fat)
- Average grams per day (e.g. "68g")
- Percentage of total kcal (e.g. "28%")
- A thin 3px progress bar below each row, filled proportionally

#### Target comparison row

Below the three macro rows, separated by a hairline divider:
- Label: "TARGET SPLIT" in small grey uppercase
- Values: `P 30% · C 45% · F 25%` (sourced from user's macro target settings, not hardcoded)
- This lets the user instantly compare actual vs. target without any calculation.

#### Empty state (fewer than 2 days logged in the period)

Show: *"Log at least 2 days to see your macro split."* — grey placeholder text centred in the card where the chart would be.

---

## Empty States

The Statistics screen must handle the case where the user has just installed the app and has no data.

| Scenario | Screen behaviour |
|----------|-----------------|
| No days logged at all | Show all four components in empty state. Streak = 0 with "Start your streak today!". Days on target = "0/0". Bar chart shows 7 grey stub bars. Macro donut shows placeholder text. |
| 1 day logged | Streak = 1. Days on target = "1/1". Bar chart shows 1 coloured bar + 6 grey stubs. Macro donut shows placeholder ("Log at least 2 days…"). |
| All days in period not logged | Bar chart shows all grey stubs. Average pill shows "No data yet". Macro donut shows placeholder. |

---

## Data Requirements

The Statistics screen requires the following data to be available from the app's local database:

| Data point | Source | Notes |
|------------|--------|-------|
| Daily net calorie total per day | Sum of all food log entries for each calendar date | Already tracked for Dashboard |
| Daily calorie target | User profile — `daily_calorie_target` field | Computed by SPEC-001 or existing calculation |
| Daily macro totals (P/C/F grams) per day | Sum of macro fields across all food log entries for each date | Already tracked for macro bars |
| Food log existence per day | Any log entry for a given date = "logged" | Needed for streak calculation |
| User's target macro split (%) | User profile — macro target fields | May need to be added if not yet stored |
| User's personal best streak | Computed and stored, or computed on-demand | See streak edge cases |

---

## User Stories

**US-01** — As a user who has been logging for a week, I want to see whether I hit my calorie target each day, so that I can understand my consistency and adjust my habits.

**US-02** — As a user who is struggling to lose weight despite logging, I want to see my average macro split over the past month, so that I can identify whether I am overeating carbs or fat relative to my target.

**US-03** — As a first-time user who has only been logging for 2 days, I want to see a sensible, non-broken screen even with minimal data, so that the app feels polished from day one.

**US-04** — As a user who logged consistently for 2 weeks but missed 3 days, I want to see my days-on-target fraction, so that I understand my overall consistency rate rather than feeling that a missed day "ruined" my progress.

**US-05** — As a motivated user, I want to see my current day streak and personal best, so that I am encouraged to keep logging daily to beat my record.

---

## Requirements

### P0 — Must Have

| ID | Requirement |
|----|-------------|
| REQ-ST-01 | Replace "History" tab with "Statistics" tab in bottom navigation (same position, index 1) |
| REQ-ST-02 | Statistics tab shows a fixed green header with "Statistics" title and a 7D/14D/30D period toggle, defaulting to 7D |
| REQ-ST-03 | Streak card shows current consecutive logging streak and all-time personal best |
| REQ-ST-04 | Days on Target card shows X/Y fraction with dot indicators (7D) or progress bar (14D/30D) |
| REQ-ST-05 | Calorie bar chart shows one bar per day for the selected period, coloured by target-hit status, with a dashed target line |
| REQ-ST-06 | Bar chart shows an average pill below the legend (mean of logged days only) |
| REQ-ST-07 | Macro donut shows average Protein/Carbs/Fat split with grams, percentages, and a target comparison row |
| REQ-ST-08 | All four components update when the period toggle is changed |
| REQ-ST-09 | All empty states are handled gracefully (no crashes, no broken charts, no zero-division errors) |
| REQ-ST-10 | Screen is scrollable — all content accessible on all screen sizes including small phones (360px wide) |

### P1 — Nice to Have (post-launch)

| ID | Requirement |
|----|-------------|
| REQ-ST-11 | Tapping a bar in the calorie chart navigates to that day's log on the Dashboard (date navigation) |
| REQ-ST-12 | Tapping the Streak card shows a mini calendar of logged days for the current streak |
| REQ-ST-13 | Add a "best week" callout: highlights the 7-day window in the 30D view with the highest on-target rate |

### P2 — Future (v2)

| ID | Requirement |
|----|-------------|
| REQ-ST-14 | Logging consistency heatmap (GitHub-style calendar, last 3 months) |
| REQ-ST-15 | Average calories per meal slot (Breakfast / Lunch / Dinner / Snacks) — horizontal bar chart |
| REQ-ST-16 | Top 5 most frequently logged foods |
| REQ-ST-17 | Milestones and achievement badges (first week, 1kg lost, 30-day streak) |

---

## Acceptance Criteria

### Navigation
- [ ] Bottom nav shows "Statistics" in place of "History" at index position 1
- [ ] Tapping the Statistics tab navigates to the Statistics screen
- [ ] The Statistics tab icon is active (green) when on the Statistics screen
- [ ] The History screen no longer exists as a navigable destination

### Period Toggle
- [ ] Screen opens with 7D selected by default every time
- [ ] Tapping 14D updates all components to show 14-day data
- [ ] Tapping 30D updates all components to show 30-day data
- [ ] Period selection is not persisted — always resets to 7D on next open

### Streak Card
- [ ] Displays correct consecutive logging streak based on today's local date
- [ ] If user has not logged today, streak shows the streak value as of yesterday (not reduced yet)
- [ ] If user has never logged, shows "0" and "Start your streak today!"
- [ ] Personal best reflects all-time maximum streak, not just the current period

### Days on Target Card
- [ ] Fraction X/Y counts only days with at least one log entry as Y
- [ ] X counts days where net kcal is within ±10% of daily calorie target
- [ ] 7D view shows 7 individual dot indicators
- [ ] 14D/30D view shows a progress bar with % label
- [ ] Dots correctly coloured: green = hit, red = missed, grey = no log

### Calorie Bar Chart
- [ ] Shows correct number of bars for selected period (7, 14, or 30)
- [ ] Each bar height is proportional to that day's logged net kcal
- [ ] Bars coloured correctly per the colour logic table
- [ ] Dashed target line drawn at the user's daily calorie target value
- [ ] Target line label shows the numeric calorie target
- [ ] Days with no log entry show a short grey stub bar
- [ ] Average pill shows mean kcal across logged days only (unlogged days excluded)
- [ ] No crash or visual error when all days in the period are unlogged
- [ ] 30D view omits individual bar value labels to prevent crowding

### Macro Donut
- [ ] Donut segments sized correctly to reflect average Protein/Carbs/Fat percentage
- [ ] Centre of donut shows average daily kcal for the period
- [ ] Legend rows show macro name, average grams/day, and percentage
- [ ] Mini progress bar below each legend row filled proportionally
- [ ] Target comparison row shows the user's configured target split (P/C/F %)
- [ ] If fewer than 2 days logged, donut area shows placeholder message instead of chart
- [ ] No zero-division error if total logged kcal = 0

---

## Success Metrics

| Metric | Target | Timeframe |
|--------|--------|-----------|
| Statistics tab tap rate (DAU who visit Stats) | ≥ 30% of daily active users | 2 weeks post-launch |
| Day-7 retention vs. baseline (pre-feature) | Improve by ≥ 5 percentage points | 30 days post-launch |
| Average logging streak length | Increase vs. pre-feature baseline | 30 days post-launch |
| Crash rate on Statistics screen | 0 crashes per 1,000 sessions | Ongoing |

---

## Open Questions

| # | Question | Owner | Blocking? |
|---|----------|-------|-----------|
| OQ-01 | Does the app currently store per-day macro totals, or must they be computed on-demand by summing individual food log entries? If on-demand, are there performance concerns for the 30D view with many log entries? | Engineering | Yes — affects data layer design |
| OQ-02 | Is there a configured macro target split (P/C/F %) stored in the user profile, or is it currently hardcoded? The "Target Split" row in the macro legend requires this. | Engineering | Yes — needed for REQ-ST-07 |
| OQ-03 | Should the personal best streak be pre-computed and stored, or computed on-demand by scanning all log entries? For users with many months of data, on-demand may be slow. | Engineering | No — can compute on first load and cache |
| OQ-04 | For the 30D bar chart, should weekends be visually distinguished (e.g. slightly different bar background) to help users spot weekend vs. weekday patterns? | Design | No — can decide post-launch |

---

## Implementation Order (Suggested)

1. **REQ-ST-01** — Navigation change (remove History tab, add Statistics tab). Lowest risk, unblocks testing the new nav immediately.
2. **REQ-ST-03 + REQ-ST-04** — Streak and Days on Target cards. Pure computation on existing log data; no new chart library needed.
3. **REQ-ST-05 + REQ-ST-06** — Calorie bar chart. Requires a simple bar chart widget; can use `fl_chart` or `syncfusion_flutter_charts` if already in the project.
4. **REQ-ST-07** — Macro donut chart. Requires a donut/pie chart widget. Confirm OQ-02 (macro target storage) before starting.
5. **REQ-ST-02 + REQ-ST-08** — Period toggle wiring. Connect toggle to all components.
6. **REQ-ST-09 + REQ-ST-10** — Empty states and scroll testing across device sizes.
