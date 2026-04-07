-- =====================
-- FOODS TABLE (pre-seeded, read-only)
-- =====================
CREATE TABLE foods (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  brand TEXT,
  category TEXT NOT NULL,
  calories_per_100g REAL NOT NULL,
  protein_per_100g REAL NOT NULL DEFAULT 0,
  carbs_per_100g REAL NOT NULL DEFAULT 0,
  fat_per_100g REAL NOT NULL DEFAULT 0,
  fiber_per_100g REAL DEFAULT 0,
  sugar_per_100g REAL DEFAULT 0,
  sodium_per_100mg REAL DEFAULT 0,
  default_serving_g REAL NOT NULL DEFAULT 100,
  serving_description TEXT,
  is_gluten_free INTEGER NOT NULL DEFAULT 0,
  gluten_status TEXT NOT NULL DEFAULT 'unknown'
    CHECK(gluten_status IN 
      ('gluten_free','contains_gluten','may_contain','unknown')),
  is_custom INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_foods_name ON foods(name);
CREATE INDEX idx_foods_category ON foods(category);
CREATE INDEX idx_foods_gluten ON foods(gluten_status);

-- =====================
-- FOOD LOGS TABLE
-- =====================
CREATE TABLE food_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  meal_type TEXT NOT NULL 
    CHECK(meal_type IN ('breakfast','lunch','dinner','snacks')),
  food_id INTEGER NOT NULL REFERENCES foods(id),
  quantity_g REAL NOT NULL,
  calories REAL NOT NULL,
  protein REAL NOT NULL DEFAULT 0,
  carbs REAL NOT NULL DEFAULT 0,
  fat REAL NOT NULL DEFAULT 0,
  gluten_status TEXT NOT NULL DEFAULT 'unknown',
  logged_at TEXT NOT NULL
);

CREATE INDEX idx_food_logs_date ON food_logs(date);

-- =====================
-- EXERCISES TABLE (pre-seeded, read-only)
-- =====================
CREATE TABLE exercises (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  met_value REAL NOT NULL,
  description TEXT
);

CREATE INDEX idx_exercises_name ON exercises(name);

-- =====================
-- EXERCISE LOGS TABLE
-- =====================
CREATE TABLE exercise_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  exercise_id INTEGER NOT NULL REFERENCES exercises(id),
  duration_minutes INTEGER NOT NULL,
  calories_burned REAL NOT NULL,
  logged_at TEXT NOT NULL
);

CREATE INDEX idx_exercise_logs_date ON exercise_logs(date);

-- =====================
-- WATER LOGS TABLE
-- =====================
CREATE TABLE water_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  amount_ml INTEGER NOT NULL,
  logged_at TEXT NOT NULL
);

CREATE INDEX idx_water_logs_date ON water_logs(date);

-- =====================
-- WEIGHT LOGS TABLE
-- =====================
CREATE TABLE weight_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,
  weight_kg REAL NOT NULL,
  logged_at TEXT NOT NULL
);

CREATE INDEX idx_weight_logs_date ON weight_logs(date);

-- =====================
-- USER PROFILE TABLE (single row)
-- =====================
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY DEFAULT 1,
  name TEXT,
  date_of_birth TEXT,
  gender TEXT CHECK(gender IN ('male','female','other')),
  height_cm REAL,
  weight_kg REAL,
  activity_level TEXT CHECK(activity_level IN
    ('sedentary','lightly_active','moderately_active','very_active')),
  goal_type TEXT CHECK(goal_type IN ('lose','maintain','gain')),
  calorie_target REAL,
  protein_target_g REAL,
  carbs_target_g REAL,
  fat_target_g REAL,
  water_target_ml INTEGER DEFAULT 2000,
  is_gluten_free INTEGER NOT NULL DEFAULT 1,
  db_version INTEGER DEFAULT 1,
  onboarding_complete INTEGER DEFAULT 0
);