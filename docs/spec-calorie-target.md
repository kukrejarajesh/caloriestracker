# Feature Spec: Personalised Daily Calorie Target
**App:** CalorieTracker  
**Feature ID:** SPEC-001  
**Author:** Product Review  
**Date:** April 20, 2026  
**Status:** Draft — ready for engineering review

---

## Problem Statement

The app currently collects age, gender, height, weight, activity level, and goal direction (Lose / Maintain / Gain weight) during onboarding, and uses these to calculate a fixed daily calorie target. However, it does not ask **how fast** the user wants to achieve their goal or **what their target weight is**. As a result, the calorie target shown (e.g. 2228 kcal) is a static TDEE-based estimate with no connection to when the user wants to reach their goal.

This means two users with identical profiles but different ambitions — one wanting to lose 3 kg before a wedding in 6 weeks, another wanting to lose 20 kg over 6 months — receive the exact same calorie recommendation. The feature is therefore not truly personalised, which undermines the core value proposition of the app.

---

## Goals

1. **Personalise the calorie target** by factoring in the user's target weight and desired pace of change alongside existing inputs (age, gender, height, current weight, activity level).
2. **Make the target meaningful** — users should be able to see a clear connection between their daily calorie goal and their weight goal timeline.
3. **Prevent unsafe calorie targets** — the system must enforce evidence-based minimum and maximum daily calorie thresholds regardless of user input.
4. **Dynamically recalculate the target** as the user logs weight over time, so the recommendation stays accurate as their body composition changes.
5. **Keep onboarding friction low** — the additional inputs should take no more than one extra step and require no nutritional knowledge from the user.

---

## Non-Goals

- **This spec does not cover macro (protein/carbs/fat) target personalisation.** Macro targets will continue to use standard percentage splits (e.g. 30% protein, 45% carbs, 25% fat) for v1.
- **This spec does not cover exercise-adjusted calorie targets.** The "Burned" calorie field already exists; integrating exercise into the calorie goal calculation is a separate feature.
- **This spec does not cover medical or clinical diet plans.** The app is for general wellness tracking, not therapeutic nutrition. Users with medical conditions should be directed to consult a professional.
- **This spec does not add body fat percentage or lean mass inputs.** BMI and weight-based calculations are sufficient for v1.
- **This spec does not add scheduled reminders or notifications** for when the user is off-track toward their goal.

---

## Background: How Calorie Targets Should Be Calculated

This section provides the engineering team with the complete calculation logic.

### Step 1 — Calculate Basal Metabolic Rate (BMR)
Use the **Mifflin-St Jeor equation** (most accurate for general population):

```
Men:   BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) + 5
Women: BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) − 161
```

### Step 2 — Calculate Total Daily Energy Expenditure (TDEE)
Multiply BMR by the activity multiplier:

| Activity Level | Multiplier |
|----------------|-----------|
| Sedentary | × 1.2 |
| Lightly Active | × 1.375 |
| Moderately Active | × 1.55 |
| Very Active | × 1.725 |
| Extra Active *(future)* | × 1.9 |

`TDEE = BMR × activity_multiplier`

### Step 3 — Calculate Required Daily Calorie Deficit or Surplus

```
weight_to_change_kg = current_weight_kg − target_weight_kg
  (positive = weight loss, negative = weight gain)

total_kcal_to_change = weight_to_change_kg × 7700
  (1 kg body fat ≈ 7700 kcal)

weekly_kcal_change = total_kcal_to_change / duration_weeks
daily_kcal_change  = weekly_kcal_change / 7
```

### Step 4 — Calculate Daily Calorie Target

```
daily_calorie_target = TDEE − daily_kcal_change
  (subtract for weight loss, add for weight gain, TDEE unchanged for maintain)
```

### Step 5 — Apply Safety Bounds

| Scenario | Minimum | Maximum adjustment |
|----------|---------|--------------------|
| Weight loss (Men) | 1500 kcal/day | Max 1000 kcal/day deficit (≈ 1 kg/week loss) |
| Weight loss (Women) | 1200 kcal/day | Max 1000 kcal/day deficit (≈ 1 kg/week loss) |
| Weight gain | TDEE + 200 kcal | Max TDEE + 500 kcal/day surplus |
| Maintain | TDEE | No adjustment |

If the calculated target falls below the minimum, **clamp to the minimum and show a warning**: *"Your goal is ambitious. We've set a safe minimum target. Consider extending your timeline."*

### Worked Example

| Input | Value |
|-------|-------|
| Gender | Male |
| Age | 36 |
| Height | 172 cm |
| Current Weight | 86 kg |
| Activity Level | Moderately Active |
| Goal | Lose Weight |
| Target Weight | 80 kg |
| Duration | 12 weeks |

```
BMR  = (10×86) + (6.25×172) − (5×36) + 5 = 860 + 1075 − 180 + 5 = 1760 kcal
TDEE = 1760 × 1.55 = 2728 kcal

weight_to_lose = 86 − 80 = 6 kg
total_deficit  = 6 × 7700 = 46,200 kcal
weekly_deficit = 46,200 / 12 = 3,850 kcal/week
daily_deficit  = 3,850 / 7 = 550 kcal/day

daily_target = 2728 − 550 = 2178 kcal/day  ✅ (above 1500 minimum)
```

> **Note on current app behaviour:** The app currently shows 2228 kcal for this user profile with no target weight or duration specified. This appears to apply a fixed ~500 kcal deficit from TDEE. The new feature replaces this fixed approach with a user-driven calculation.

---

## User Stories

### Persona: First-time user setting up the app

**US-01** — As a new user who wants to lose weight, I want to enter my target weight and how many weeks I want to achieve it in, so that the app gives me a daily calorie target that is specific to my goal rather than a generic estimate.

**US-02** — As a new user, I want the app to tell me what weekly weight loss rate my goal implies (e.g. "0.5 kg per week"), so that I can understand whether my goal is realistic before committing.

**US-03** — As a new user with an aggressive goal (e.g. lose 10 kg in 4 weeks), I want the app to warn me that my target requires an unsafe calorie restriction and suggest a safer timeline, so that I don't harm my health.

**US-04** — As a new user who wants to maintain weight, I want to skip the target weight and duration inputs, so that my onboarding is not unnecessarily long.

### Persona: Returning user updating their goal

**US-05** — As a returning user who has lost some weight, I want to update my current weight and keep my target weight the same, so that the app recalculates my daily calorie target based on my new progress.

**US-06** — As a returning user, I want to see how my daily calorie target has changed since I started, so that I can understand how my body's needs have evolved as I've lost weight.

---

## Requirements

### P0 — Must Have (v1 ships with these)

**REQ-01: Target Weight input in onboarding (Goal step)**
- Add a numeric input field "Target weight" (in kg or lbs, matching the user's unit preference) to the Goal step of onboarding.
- Only display this field when the user selects "Lose Weight" or "Gain Weight". Hide it for "Maintain Weight".
- Validate: target weight must be less than current weight for Lose goal; greater than current weight for Gain goal. Show inline error if violated.

**REQ-02: Pace selector in onboarding (Goal step)**
- Add a pace selector below the target weight field, offering pre-set weekly rates:

| Option | Weekly change | Deficit/Surplus |
|--------|--------------|-----------------|
| Gradual | 0.25 kg/week | ~275 kcal/day |
| Moderate *(default)* | 0.5 kg/week | ~550 kcal/day |
| Active | 0.75 kg/week | ~825 kcal/day |
| Aggressive | 1.0 kg/week | ~1100 kcal/day |

- Default to "Moderate" on first load.
- Dynamically show the implied timeline: *"At this pace you'll reach your goal in ~X weeks"* — update in real time as target weight or pace changes.
- If "Aggressive" would put the user below the safe minimum calories, disable that option and show: *"Not available for your current goal. Choose a smaller target or slower pace."*

**REQ-03: Calorie target calculation using new inputs**
- Replace the current fixed-deficit calculation with the formula defined in the Background section above.
- Inputs to the formula: current weight, height, age (derived from DOB), gender, activity level, target weight (if not Maintain), pace selection (weekly rate).
- Output: `daily_calorie_target` stored in user profile.
- Apply safety bounds as specified in Step 5 of the Background section.

**REQ-04: Display goal summary on Dashboard**
- Below the calorie ring on the Dashboard, add a small goal summary line:
  `"Goal: Lose 6 kg · ~12 weeks at current pace"`
- Tapping it navigates to the Goal section in Profile where the user can edit.
- For Maintain goal: show `"Goal: Maintain weight"`

**REQ-05: Recalculate target when weight is updated**
- When the user logs a new weight entry in the Weight Trend screen, recalculate the daily calorie target using the updated current weight (keeping target weight and pace unchanged).
- Show a brief confirmation: *"Your daily target has been updated to X kcal based on your new weight."*
- Do not auto-recalculate silently — always inform the user.

**REQ-06: Edit goal and pace from Profile screen**
- The Profile screen must allow editing of: Target Weight, Pace.
- Changes trigger immediate recalculation and update the daily calorie target.
- Show the new calculated target before saving: *"Your new daily target will be X kcal/day."*

### P1 — Nice to Have (fast follow after launch)

**REQ-07: Estimated completion date instead of duration**
- Allow the user to enter a target date (e.g. "I want to reach this by June 1") as an alternative to selecting a pace.
- Back-calculate the required pace and validate it is within safe bounds.

**REQ-08: Progress indicator toward weight goal**
- On the Weight Trend screen, show a projected completion date based on current rate of weight change (rolling 2-week average), and compare it to the goal timeline.
- E.g. *"At your current pace you'll reach 80 kg by July 12 — 3 weeks behind your goal."*

**REQ-09: Calorie target adjustment nudge**
- If the user's logged net calories average more than 20% above/below target over the past 7 days, show a gentle nudge on the Dashboard: *"Your average this week was X kcal above target. Want to adjust your goal?"*

### P2 — Future Considerations (design should not block these)

- Macro target personalisation (protein g/kg of body weight for muscle-building goals)
- Integration with exercise logging to dynamically add back burned calories to the daily budget
- Body fat % input for more accurate BMR calculation using lean mass
- Support for non-linear weight loss goals (maintenance phases, refeed days)

---

## Success Metrics

### Leading Indicators (measure within 2 weeks of launch)
| Metric | Target |
|--------|--------|
| Onboarding completion rate with new Goal step | ≥ 85% (should not drop vs. current) |
| % of users who set a target weight (not Maintain) | ≥ 60% |
| % of users who change from the default "Moderate" pace | ≥ 20% (validates that the choice matters to users) |
| Support tickets about "calorie target seems wrong" | Decrease vs. baseline |

### Lagging Indicators (measure at 30 and 90 days)
| Metric | Target |
|--------|--------|
| Day-7 retention of users who completed the new Goal step | ≥ 40% |
| % of users who log weight at least once per week | ≥ 30% (recalculation gives a reason to log weight) |
| Average daily log streak (days logged consecutively) | Increase vs. pre-feature baseline |

---

## Open Questions

| # | Question | Owner | Blocking? |
|---|----------|-------|-----------|
| OQ-01 | Should we use Mifflin-St Jeor or Harris-Benedict? Mifflin-St Jeor is generally more accurate for non-obese adults; Harris-Benedict is older but widely used. | Engineering / Product | No — default to Mifflin-St Jeor |
| OQ-02 | When the user updates their weight and the calorie target changes, should we update historical log entries' "remaining" display, or only apply the new target going forward? | Engineering | Yes — need to decide before REQ-05 |
| OQ-03 | What happens if the user's current weight reaches their target weight? Should the goal automatically switch to "Maintain"? Or prompt the user? | Product | No — but should be addressed before REQ-08 |
| OQ-04 | For the Gain Weight goal, should we cap the surplus more aggressively for users under 18 or over 65? | Product | No — out of scope for v1 (no age-gating in current app) |
| OQ-05 | Should the pace selector show kcal/day deficit alongside kg/week, for users who think in calories rather than weight? | Design | No — can A/B test post-launch |

---

## UI / Screen Changes Summary

| Screen | Change Required |
|--------|----------------|
| Onboarding — Step 4 (Your Goal) | Add: Target Weight input, Pace selector, live timeline preview |
| Dashboard | Add: Goal summary line below calorie ring |
| Weight Trend | Add: Recalculation prompt after logging weight |
| Profile | Add: Target Weight and Pace fields; show new calculated target before saving |

---

## Timeline Considerations

- **No hard deadline** — this is a pre-Play Store launch feature.
- Recommended to implement before first Play Store release, as the current fixed calorie target is a core accuracy gap.
- **Suggested order of implementation:**
  1. REQ-03 (calculation logic) — pure backend/logic, no UI change
  2. REQ-01 + REQ-02 (onboarding Goal step inputs)
  3. REQ-04 (Dashboard goal summary)
  4. REQ-05 + REQ-06 (weight update recalculation + Profile editing)
  5. P1 items post-launch based on user feedback

---

## Acceptance Criteria

### Onboarding — Goal Step

- [ ] "Target Weight" field appears when user selects "Lose Weight" or "Gain Weight"; hidden for "Maintain Weight"
- [ ] Entering a target weight greater than current weight while on "Lose Weight" shows inline error: *"Target weight must be less than your current weight"*
- [ ] Pace selector shows 4 options: Gradual / Moderate (default) / Active / Aggressive
- [ ] Timeline preview updates in real time as user changes target weight or pace: *"~X weeks at this pace"*
- [ ] "Aggressive" option is disabled and shows explanation if it would result in < 1500 kcal/day (men) or < 1200 kcal/day (women)
- [ ] Tapping "Get Started" saves target weight, pace, and calculated daily calorie target to user profile

### Dashboard

- [ ] Goal summary line is visible below the calorie ring
- [ ] For Lose/Gain: summary shows target, estimated weeks, and current pace
- [ ] For Maintain: summary shows "Goal: Maintain weight"
- [ ] Tapping the summary line navigates to the Goal section of the Profile screen

### Weight Update Recalculation

- [ ] After logging a new weight entry, the daily calorie target is recalculated
- [ ] A confirmation message shows the new target: *"Your daily target has been updated to X kcal"*
- [ ] The recalculation uses: new current weight + existing target weight + existing pace selection
- [ ] If the new weight equals or passes the target weight, the user is prompted: *"You've reached your goal! Would you like to switch to Maintain?"*

### Profile Editing

- [ ] Target Weight and Pace fields are editable in Profile
- [ ] Changing either field shows a preview of the new calculated daily target before saving
- [ ] Saving updates the calorie target displayed on the Dashboard immediately
