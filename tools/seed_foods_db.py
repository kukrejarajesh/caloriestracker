"""
seed_foods_db.py — Generates assets/foods.db with curated foods.

Run from the tools/ directory:
    py seed_foods_db.py

Requires: tag_gluten.py in the same directory, schema.sql in the same directory.
Output:   ../assets/foods.db

IMPORTANT: After running this, bump DbSeeder.currentSeedVersion in
lib/data/seed/db_seeder.dart. Both changes must be in the same commit.
"""

import re
import sqlite3
import sys
from pathlib import Path

HERE = Path(__file__).parent
ASSETS_DIR = HERE.parent / "assets"
OUTPUT = ASSETS_DIR / "foods.db"
SCHEMA_SQL = HERE / "schema.sql"

sys.path.insert(0, str(HERE))
from tag_gluten import tag_all  # noqa: E402
from merged_foods_final import FOODS

VALID_CATEGORIES = [
    "Grains/Cereals", "Dairy", "Meat/Poultry", "Fish/Seafood",
    "Vegetables", "Fruits", "Legumes/Pulses", "Nuts/Seeds",
    "Beverages", "Snacks", "Sweets/Desserts", "Oils/Fats",
    "Spices/Condiments",
]

# ---------------------------------------------------------------------------
# FOODS DATA
# Fields: name, brand, category, calories_per_100g, protein_per_100g,
#         carbs_per_100g, fat_per_100g, fiber_per_100g, sugar_per_100g,
#         sodium_per_100mg, default_serving_g, serving_description
# gluten_status + is_gluten_free are filled automatically by tag_all()
# ---------------------------------------------------------------------------
# FOODS = [

#     # ── Grains / Cereals ────────────────────────────────────────────────────
#     {"name": "Basmati Rice (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 349, "protein_per_100g": 7.5, "carbs_per_100g": 77.0, "fat_per_100g": 0.5, "fiber_per_100g": 0.4, "sugar_per_100g": 0.1, "sodium_per_100mg": 1.0, "default_serving_g": 80, "serving_description": "80g dry (yields ~1 katori)"},
#     {"name": "Basmati Rice (cooked)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 130, "protein_per_100g": 2.7, "carbs_per_100g": 28.2, "fat_per_100g": 0.3, "fiber_per_100g": 0.4, "sugar_per_100g": 0.1, "sodium_per_100mg": 1.0, "default_serving_g": 150, "serving_description": "1 katori cooked"},
#     {"name": "Brown Rice (cooked)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 123, "protein_per_100g": 2.6, "carbs_per_100g": 25.6, "fat_per_100g": 0.9, "fiber_per_100g": 1.8, "sugar_per_100g": 0.4, "sodium_per_100mg": 1.0, "default_serving_g": 150, "serving_description": "1 katori cooked"},
#     {"name": "Idli", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 58, "protein_per_100g": 2.0, "carbs_per_100g": 11.4, "fat_per_100g": 0.4, "fiber_per_100g": 0.5, "sugar_per_100g": 0.3, "sodium_per_100mg": 120.0, "default_serving_g": 120, "serving_description": "2 medium idlis"},
#     {"name": "Dosa (plain)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 168, "protein_per_100g": 3.9, "carbs_per_100g": 25.0, "fat_per_100g": 6.0, "fiber_per_100g": 0.5, "sugar_per_100g": 0.4, "sodium_per_100mg": 200.0, "default_serving_g": 90, "serving_description": "1 medium dosa"},
#     {"name": "Poha (cooked)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 110, "protein_per_100g": 2.5, "carbs_per_100g": 23.0, "fat_per_100g": 1.0, "fiber_per_100g": 0.5, "sugar_per_100g": 0.5, "sodium_per_100mg": 150.0, "default_serving_g": 200, "serving_description": "1 bowl"},
#     {"name": "Upma", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 160, "protein_per_100g": 3.5, "carbs_per_100g": 22.0, "fat_per_100g": 6.0, "fiber_per_100g": 1.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 300.0, "default_serving_g": 200, "serving_description": "1 bowl"},
#     {"name": "Roti (wheat)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 297, "protein_per_100g": 9.0, "carbs_per_100g": 55.0, "fat_per_100g": 3.7, "fiber_per_100g": 2.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 5.0, "default_serving_g": 40, "serving_description": "1 medium roti"},
#     {"name": "Whole Wheat Bread", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 247, "protein_per_100g": 9.7, "carbs_per_100g": 41.0, "fat_per_100g": 4.2, "fiber_per_100g": 6.0, "sugar_per_100g": 5.0, "sodium_per_100mg": 400.0, "default_serving_g": 30, "serving_description": "1 slice"},
#     {"name": "White Bread", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 265, "protein_per_100g": 8.0, "carbs_per_100g": 50.0, "fat_per_100g": 3.5, "fiber_per_100g": 2.0, "sugar_per_100g": 5.0, "sodium_per_100mg": 450.0, "default_serving_g": 30, "serving_description": "1 slice"},
#     {"name": "Naan", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 310, "protein_per_100g": 9.0, "carbs_per_100g": 56.0, "fat_per_100g": 5.0, "fiber_per_100g": 2.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 400.0, "default_serving_g": 90, "serving_description": "1 naan"},
#     {"name": "Paratha (plain)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 326, "protein_per_100g": 7.0, "carbs_per_100g": 45.0, "fat_per_100g": 13.0, "fiber_per_100g": 2.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 250.0, "default_serving_g": 60, "serving_description": "1 paratha"},
#     {"name": "Semolina / Sooji (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 360, "protein_per_100g": 12.7, "carbs_per_100g": 72.8, "fat_per_100g": 1.1, "fiber_per_100g": 3.9, "sugar_per_100g": 0.5, "sodium_per_100mg": 1.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Maida (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 348, "protein_per_100g": 9.0, "carbs_per_100g": 73.0, "fat_per_100g": 1.0, "fiber_per_100g": 1.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 2.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Whole Wheat Atta (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 340, "protein_per_100g": 12.0, "carbs_per_100g": 68.0, "fat_per_100g": 1.7, "fiber_per_100g": 10.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 2.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Quinoa (cooked)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 120, "protein_per_100g": 4.4, "carbs_per_100g": 21.3, "fat_per_100g": 1.9, "fiber_per_100g": 2.8, "sugar_per_100g": 0.9, "sodium_per_100mg": 7.0, "default_serving_g": 150, "serving_description": "1 katori cooked"},
#     {"name": "Oats (rolled, raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 389, "protein_per_100g": 16.9, "carbs_per_100g": 66.3, "fat_per_100g": 6.9, "fiber_per_100g": 10.6, "sugar_per_100g": 1.0, "sodium_per_100mg": 2.0, "default_serving_g": 40, "serving_description": "40g dry"},
#     {"name": "Oats (cooked / porridge)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 71, "protein_per_100g": 2.5, "carbs_per_100g": 12.0, "fat_per_100g": 1.5, "fiber_per_100g": 1.7, "sugar_per_100g": 0.3, "sodium_per_100mg": 4.0, "default_serving_g": 250, "serving_description": "1 bowl cooked"},
#     {"name": "Corn / Maize (boiled)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 96, "protein_per_100g": 3.4, "carbs_per_100g": 21.0, "fat_per_100g": 1.5, "fiber_per_100g": 2.4, "sugar_per_100g": 4.5, "sodium_per_100mg": 15.0, "default_serving_g": 100, "serving_description": "1 cob kernels"},
#     {"name": "Makki Atta / Cornmeal (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 362, "protein_per_100g": 8.1, "carbs_per_100g": 76.8, "fat_per_100g": 3.6, "fiber_per_100g": 7.3, "sugar_per_100g": 0.6, "sodium_per_100mg": 35.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Buckwheat (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 343, "protein_per_100g": 13.3, "carbs_per_100g": 71.5, "fat_per_100g": 3.4, "fiber_per_100g": 10.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 1.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Jowar / Sorghum (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 349, "protein_per_100g": 10.4, "carbs_per_100g": 72.6, "fat_per_100g": 1.9, "fiber_per_100g": 6.3, "sugar_per_100g": 1.1, "sodium_per_100mg": 6.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Bajra / Pearl Millet (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 361, "protein_per_100g": 11.6, "carbs_per_100g": 67.5, "fat_per_100g": 5.0, "fiber_per_100g": 11.5, "sugar_per_100g": 0.5, "sodium_per_100mg": 10.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Ragi / Finger Millet (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 328, "protein_per_100g": 7.3, "carbs_per_100g": 72.0, "fat_per_100g": 1.3, "fiber_per_100g": 3.6, "sugar_per_100g": 1.5, "sodium_per_100mg": 11.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Pasta (cooked)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 158, "protein_per_100g": 5.8, "carbs_per_100g": 31.0, "fat_per_100g": 0.9, "fiber_per_100g": 1.8, "sugar_per_100g": 0.6, "sodium_per_100mg": 1.0, "default_serving_g": 180, "serving_description": "1 serving cooked"},
#     {"name": "Rice Noodles (cooked)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 109, "protein_per_100g": 0.9, "carbs_per_100g": 25.0, "fat_per_100g": 0.2, "fiber_per_100g": 0.9, "sugar_per_100g": 0.1, "sodium_per_100mg": 10.0, "default_serving_g": 180, "serving_description": "1 serving cooked"},
#     {"name": "Sabudana / Tapioca Pearls (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 350, "protein_per_100g": 0.2, "carbs_per_100g": 86.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.5, "sugar_per_100g": 0.5, "sodium_per_100mg": 1.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Murmura / Puffed Rice", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 375, "protein_per_100g": 7.5, "carbs_per_100g": 84.0, "fat_per_100g": 0.5, "fiber_per_100g": 1.0, "sugar_per_100g": 0.3, "sodium_per_100mg": 5.0, "default_serving_g": 30, "serving_description": "1 cup"},
#     {"name": "Poha / Rice Flakes (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 345, "protein_per_100g": 7.8, "carbs_per_100g": 76.9, "fat_per_100g": 1.0, "fiber_per_100g": 1.2, "sugar_per_100g": 0.5, "sodium_per_100mg": 5.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Dalia / Broken Wheat (raw)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 342, "protein_per_100g": 11.5, "carbs_per_100g": 71.0, "fat_per_100g": 1.5, "fiber_per_100g": 8.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 2.0, "default_serving_g": 50, "serving_description": "50g dry"},

#     # Indian GF flatbreads and breakfast
#     {"name": "Moong Dal Cheela", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 154, "protein_per_100g": 9.5, "carbs_per_100g": 18.0, "fat_per_100g": 5.0, "fiber_per_100g": 3.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 180.0, "default_serving_g": 80, "serving_description": "1 medium cheela"},
#     {"name": "Ragi Dosa", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 145, "protein_per_100g": 4.0, "carbs_per_100g": 24.0, "fat_per_100g": 4.0, "fiber_per_100g": 1.8, "sugar_per_100g": 0.8, "sodium_per_100mg": 180.0, "default_serving_g": 90, "serving_description": "1 medium dosa"},
#     {"name": "Ragi Roti", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 150, "protein_per_100g": 4.5, "carbs_per_100g": 30.0, "fat_per_100g": 1.5, "fiber_per_100g": 3.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 8.0, "default_serving_g": 50, "serving_description": "1 roti"},
#     {"name": "Jowar Roti", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 155, "protein_per_100g": 5.0, "carbs_per_100g": 32.0, "fat_per_100g": 1.2, "fiber_per_100g": 3.5, "sugar_per_100g": 0.8, "sodium_per_100mg": 8.0, "default_serving_g": 50, "serving_description": "1 roti"},
#     {"name": "Bajra Roti", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 165, "protein_per_100g": 5.5, "carbs_per_100g": 30.0, "fat_per_100g": 3.0, "fiber_per_100g": 4.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 10.0, "default_serving_g": 50, "serving_description": "1 roti"},
#     {"name": "Makki Roti", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 160, "protein_per_100g": 4.0, "carbs_per_100g": 33.0, "fat_per_100g": 2.0, "fiber_per_100g": 3.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 8.0, "default_serving_g": 60, "serving_description": "1 roti"},
#     {"name": "Thalipeeth (jowar-bajra)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 195, "protein_per_100g": 6.0, "carbs_per_100g": 28.0, "fat_per_100g": 7.0, "fiber_per_100g": 3.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 250.0, "default_serving_g": 70, "serving_description": "1 thalipeeth"},
#     {"name": "Kuttu Paratha", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 240, "protein_per_100g": 6.0, "carbs_per_100g": 35.0, "fat_per_100g": 9.0, "fiber_per_100g": 4.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 200.0, "default_serving_g": 60, "serving_description": "1 paratha"},
#     {"name": "Singhare ka Atta Puri", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 320, "protein_per_100g": 4.5, "carbs_per_100g": 42.0, "fat_per_100g": 15.0, "fiber_per_100g": 2.5, "sugar_per_100g": 0.5, "sodium_per_100mg": 180.0, "default_serving_g": 40, "serving_description": "1 puri"},
#     {"name": "Rice Flour Dosa", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 155, "protein_per_100g": 2.5, "carbs_per_100g": 28.0, "fat_per_100g": 4.0, "fiber_per_100g": 0.5, "sugar_per_100g": 0.3, "sodium_per_100mg": 160.0, "default_serving_g": 90, "serving_description": "1 medium dosa"},
#     {"name": "Sabudana Khichdi", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 180, "protein_per_100g": 3.5, "carbs_per_100g": 32.0, "fat_per_100g": 5.0, "fiber_per_100g": 0.8, "sugar_per_100g": 0.5, "sodium_per_100mg": 250.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Masala Dosa", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 175, "protein_per_100g": 3.5, "carbs_per_100g": 24.0, "fat_per_100g": 7.5, "fiber_per_100g": 1.2, "sugar_per_100g": 0.8, "sodium_per_100mg": 250.0, "default_serving_g": 150, "serving_description": "1 masala dosa"},
#     {"name": "Uttapam (onion)", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 140, "protein_per_100g": 3.5, "carbs_per_100g": 22.0, "fat_per_100g": 4.5, "fiber_per_100g": 1.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 200.0, "default_serving_g": 120, "serving_description": "1 uttapam"},
#     {"name": "Appam", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 130, "protein_per_100g": 2.5, "carbs_per_100g": 25.0, "fat_per_100g": 2.5, "fiber_per_100g": 0.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 100.0, "default_serving_g": 80, "serving_description": "1 appam"},
#     {"name": "Rajgira Paratha", "brand": None, "category": "Grains/Cereals", "calories_per_100g": 260, "protein_per_100g": 7.0, "carbs_per_100g": 36.0, "fat_per_100g": 10.0, "fiber_per_100g": 3.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 200.0, "default_serving_g": 60, "serving_description": "1 paratha"},

#     # ── Dairy ────────────────────────────────────────────────────────────────
#     {"name": "Full Fat Milk", "brand": None, "category": "Dairy", "calories_per_100g": 61, "protein_per_100g": 3.2, "carbs_per_100g": 4.7, "fat_per_100g": 3.3, "fiber_per_100g": 0.0, "sugar_per_100g": 4.7, "sodium_per_100mg": 44.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Skimmed Milk", "brand": None, "category": "Dairy", "calories_per_100g": 35, "protein_per_100g": 3.4, "carbs_per_100g": 5.0, "fat_per_100g": 0.1, "fiber_per_100g": 0.0, "sugar_per_100g": 5.0, "sodium_per_100mg": 44.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Toned Milk", "brand": None, "category": "Dairy", "calories_per_100g": 44, "protein_per_100g": 3.1, "carbs_per_100g": 4.9, "fat_per_100g": 1.5, "fiber_per_100g": 0.0, "sugar_per_100g": 4.9, "sodium_per_100mg": 44.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Double Toned Milk", "brand": None, "category": "Dairy", "calories_per_100g": 32, "protein_per_100g": 3.2, "carbs_per_100g": 4.6, "fat_per_100g": 0.5, "fiber_per_100g": 0.0, "sugar_per_100g": 4.6, "sodium_per_100mg": 44.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Plain Curd / Dahi", "brand": None, "category": "Dairy", "calories_per_100g": 98, "protein_per_100g": 3.1, "carbs_per_100g": 3.4, "fat_per_100g": 4.3, "fiber_per_100g": 0.0, "sugar_per_100g": 3.4, "sodium_per_100mg": 36.0, "default_serving_g": 200, "serving_description": "1 cup"},
#     {"name": "Greek Yogurt", "brand": None, "category": "Dairy", "calories_per_100g": 59, "protein_per_100g": 10.0, "carbs_per_100g": 3.6, "fat_per_100g": 0.4, "fiber_per_100g": 0.0, "sugar_per_100g": 3.2, "sodium_per_100mg": 36.0, "default_serving_g": 150, "serving_description": "1 serving"},
#     {"name": "Flavored Yogurt", "brand": None, "category": "Dairy", "calories_per_100g": 95, "protein_per_100g": 4.7, "carbs_per_100g": 17.4, "fat_per_100g": 1.0, "fiber_per_100g": 0.0, "sugar_per_100g": 14.0, "sodium_per_100mg": 60.0, "default_serving_g": 100, "serving_description": "1 small cup"},
#     {"name": "Paneer (full fat)", "brand": None, "category": "Dairy", "calories_per_100g": 265, "protein_per_100g": 18.3, "carbs_per_100g": 1.2, "fat_per_100g": 20.8, "fiber_per_100g": 0.0, "sugar_per_100g": 1.2, "sodium_per_100mg": 40.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Paneer (low fat)", "brand": None, "category": "Dairy", "calories_per_100g": 150, "protein_per_100g": 18.0, "carbs_per_100g": 2.0, "fat_per_100g": 7.0, "fiber_per_100g": 0.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 40.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Ghee", "brand": None, "category": "Dairy", "calories_per_100g": 900, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 99.5, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 2.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Butter (salted)", "brand": None, "category": "Dairy", "calories_per_100g": 717, "protein_per_100g": 0.9, "carbs_per_100g": 0.1, "fat_per_100g": 81.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.1, "sodium_per_100mg": 576.0, "default_serving_g": 10, "serving_description": "1 tsp"},
#     {"name": "Cheddar Cheese", "brand": None, "category": "Dairy", "calories_per_100g": 403, "protein_per_100g": 25.0, "carbs_per_100g": 1.3, "fat_per_100g": 33.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 621.0, "default_serving_g": 30, "serving_description": "1 slice"},
#     {"name": "Processed Cheese", "brand": None, "category": "Dairy", "calories_per_100g": 330, "protein_per_100g": 16.0, "carbs_per_100g": 5.0, "fat_per_100g": 27.0, "fiber_per_100g": 0.0, "sugar_per_100g": 4.0, "sodium_per_100mg": 1000.0, "default_serving_g": 25, "serving_description": "1 slice"},
#     {"name": "Cheese Spread", "brand": None, "category": "Dairy", "calories_per_100g": 245, "protein_per_100g": 11.0, "carbs_per_100g": 4.5, "fat_per_100g": 20.0, "fiber_per_100g": 0.0, "sugar_per_100g": 4.0, "sodium_per_100mg": 800.0, "default_serving_g": 20, "serving_description": "1 tbsp"},
#     {"name": "Heavy Cream", "brand": None, "category": "Dairy", "calories_per_100g": 340, "protein_per_100g": 2.0, "carbs_per_100g": 2.8, "fat_per_100g": 36.0, "fiber_per_100g": 0.0, "sugar_per_100g": 2.8, "sodium_per_100mg": 38.0, "default_serving_g": 30, "serving_description": "2 tbsp"},
#     {"name": "Buttermilk / Chaas", "brand": None, "category": "Dairy", "calories_per_100g": 40, "protein_per_100g": 3.3, "carbs_per_100g": 4.8, "fat_per_100g": 0.9, "fiber_per_100g": 0.0, "sugar_per_100g": 4.8, "sodium_per_100mg": 105.0, "default_serving_g": 200, "serving_description": "1 glass"},
#     {"name": "Khoya / Mawa", "brand": None, "category": "Dairy", "calories_per_100g": 421, "protein_per_100g": 14.6, "carbs_per_100g": 26.0, "fat_per_100g": 31.0, "fiber_per_100g": 0.0, "sugar_per_100g": 26.0, "sodium_per_100mg": 50.0, "default_serving_g": 50, "serving_description": "50g"},
#     {"name": "Condensed Milk (sweetened)", "brand": None, "category": "Dairy", "calories_per_100g": 321, "protein_per_100g": 7.9, "carbs_per_100g": 54.4, "fat_per_100g": 8.7, "fiber_per_100g": 0.0, "sugar_per_100g": 54.4, "sodium_per_100mg": 127.0, "default_serving_g": 30, "serving_description": "2 tbsp"},
#     {"name": "Malai / Fresh Cream", "brand": None, "category": "Dairy", "calories_per_100g": 193, "protein_per_100g": 2.9, "carbs_per_100g": 3.5, "fat_per_100g": 19.0, "fiber_per_100g": 0.0, "sugar_per_100g": 3.5, "sodium_per_100mg": 30.0, "default_serving_g": 30, "serving_description": "2 tbsp"},

#     # ── Meat / Poultry ───────────────────────────────────────────────────────
#     {"name": "Chicken Breast (cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 165, "protein_per_100g": 31.0, "carbs_per_100g": 0.0, "fat_per_100g": 3.6, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 74.0, "default_serving_g": 150, "serving_description": "1 medium breast"},
#     {"name": "Chicken Thigh (cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 209, "protein_per_100g": 26.0, "carbs_per_100g": 0.0, "fat_per_100g": 11.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 88.0, "default_serving_g": 120, "serving_description": "1 thigh"},
#     {"name": "Whole Egg (boiled)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 155, "protein_per_100g": 13.0, "carbs_per_100g": 1.1, "fat_per_100g": 11.0, "fiber_per_100g": 0.0, "sugar_per_100g": 1.1, "sodium_per_100mg": 124.0, "default_serving_g": 55, "serving_description": "1 large egg"},
#     {"name": "Egg White (raw)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 52, "protein_per_100g": 11.0, "carbs_per_100g": 0.7, "fat_per_100g": 0.2, "fiber_per_100g": 0.0, "sugar_per_100g": 0.7, "sodium_per_100mg": 166.0, "default_serving_g": 33, "serving_description": "1 egg white"},
#     {"name": "Egg Yolk (raw)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 322, "protein_per_100g": 15.9, "carbs_per_100g": 3.6, "fat_per_100g": 26.5, "fiber_per_100g": 0.0, "sugar_per_100g": 0.6, "sodium_per_100mg": 48.0, "default_serving_g": 17, "serving_description": "1 egg yolk"},
#     {"name": "Mutton / Lamb (lean, cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 258, "protein_per_100g": 25.6, "carbs_per_100g": 0.0, "fat_per_100g": 16.6, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 72.0, "default_serving_g": 150, "serving_description": "1 medium serving"},
#     {"name": "Beef (lean, cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 215, "protein_per_100g": 26.0, "carbs_per_100g": 0.0, "fat_per_100g": 12.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 55.0, "default_serving_g": 150, "serving_description": "1 medium serving"},
#     {"name": "Pork (lean, cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 242, "protein_per_100g": 27.0, "carbs_per_100g": 0.0, "fat_per_100g": 14.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 62.0, "default_serving_g": 150, "serving_description": "1 medium serving"},
#     {"name": "Turkey Breast (cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 135, "protein_per_100g": 30.0, "carbs_per_100g": 0.0, "fat_per_100g": 1.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 70.0, "default_serving_g": 150, "serving_description": "1 medium serving"},
#     {"name": "Chicken Liver (cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 165, "protein_per_100g": 24.5, "carbs_per_100g": 0.9, "fat_per_100g": 6.5, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 71.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Keema / Minced Mutton (cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 249, "protein_per_100g": 21.0, "carbs_per_100g": 2.0, "fat_per_100g": 17.0, "fiber_per_100g": 0.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 70.0, "default_serving_g": 150, "serving_description": "1 serving"},
#     {"name": "Chicken Sausage", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 186, "protein_per_100g": 12.4, "carbs_per_100g": 5.0, "fat_per_100g": 13.0, "fiber_per_100g": 0.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 720.0, "default_serving_g": 50, "serving_description": "1 sausage"},
#     {"name": "Chicken Nuggets", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 296, "protein_per_100g": 14.0, "carbs_per_100g": 18.0, "fat_per_100g": 18.0, "fiber_per_100g": 0.5, "sugar_per_100g": 0.5, "sodium_per_100mg": 510.0, "default_serving_g": 100, "serving_description": "6 pieces"},
#     {"name": "Tandoori Chicken", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 190, "protein_per_100g": 24.0, "carbs_per_100g": 3.0, "fat_per_100g": 9.0, "fiber_per_100g": 0.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 400.0, "default_serving_g": 150, "serving_description": "2 pieces"},
#     {"name": "Chicken Curry", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 148, "protein_per_100g": 14.5, "carbs_per_100g": 5.0, "fat_per_100g": 8.0, "fiber_per_100g": 0.8, "sugar_per_100g": 1.5, "sodium_per_100mg": 350.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Egg Curry", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 140, "protein_per_100g": 9.5, "carbs_per_100g": 5.5, "fat_per_100g": 9.0, "fiber_per_100g": 0.8, "sugar_per_100g": 1.5, "sodium_per_100mg": 320.0, "default_serving_g": 200, "serving_description": "1 katori (2 egg curry)"},
#     {"name": "Mutton Curry", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 195, "protein_per_100g": 16.0, "carbs_per_100g": 4.5, "fat_per_100g": 13.0, "fiber_per_100g": 0.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 380.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Paneer Tikka", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 250, "protein_per_100g": 16.0, "carbs_per_100g": 6.0, "fat_per_100g": 18.0, "fiber_per_100g": 1.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 350.0, "default_serving_g": 120, "serving_description": "6-8 pieces"},
#     {"name": "Butter Chicken", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 175, "protein_per_100g": 14.0, "carbs_per_100g": 6.0, "fat_per_100g": 11.0, "fiber_per_100g": 0.5, "sugar_per_100g": 2.5, "sodium_per_100mg": 400.0, "default_serving_g": 200, "serving_description": "1 katori curry"},

#     # ── Fish / Seafood ───────────────────────────────────────────────────────
#     {"name": "Rohu Fish (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 97, "protein_per_100g": 16.6, "carbs_per_100g": 0.0, "fat_per_100g": 3.5, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 60.0, "default_serving_g": 150, "serving_description": "1 medium piece"},
#     {"name": "Katla Fish (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 116, "protein_per_100g": 17.5, "carbs_per_100g": 0.0, "fat_per_100g": 5.2, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 60.0, "default_serving_g": 150, "serving_description": "1 medium piece"},
#     {"name": "Pomfret (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 96, "protein_per_100g": 18.0, "carbs_per_100g": 0.0, "fat_per_100g": 2.8, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 70.0, "default_serving_g": 150, "serving_description": "1 medium piece"},
#     {"name": "Surmai / King Mackerel (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 134, "protein_per_100g": 21.0, "carbs_per_100g": 0.0, "fat_per_100g": 5.5, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 90.0, "default_serving_g": 150, "serving_description": "1 medium piece"},
#     {"name": "Hilsa Fish (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 273, "protein_per_100g": 19.4, "carbs_per_100g": 0.0, "fat_per_100g": 21.8, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 60.0, "default_serving_g": 150, "serving_description": "1 medium piece"},
#     {"name": "Salmon (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 208, "protein_per_100g": 20.4, "carbs_per_100g": 0.0, "fat_per_100g": 13.4, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 59.0, "default_serving_g": 150, "serving_description": "1 fillet"},
#     {"name": "Tuna (canned in water)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 116, "protein_per_100g": 25.5, "carbs_per_100g": 0.0, "fat_per_100g": 1.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 310.0, "default_serving_g": 85, "serving_description": "1/2 can"},
#     {"name": "Prawns / Shrimp (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 99, "protein_per_100g": 24.0, "carbs_per_100g": 0.0, "fat_per_100g": 0.3, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 111.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Crab (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 97, "protein_per_100g": 19.4, "carbs_per_100g": 0.0, "fat_per_100g": 2.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 378.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Sardines (canned in oil)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 208, "protein_per_100g": 24.6, "carbs_per_100g": 0.0, "fat_per_100g": 11.5, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 505.0, "default_serving_g": 85, "serving_description": "1/2 can"},
#     {"name": "Fish Fingers", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 228, "protein_per_100g": 12.0, "carbs_per_100g": 18.0, "fat_per_100g": 11.5, "fiber_per_100g": 0.5, "sugar_per_100g": 0.5, "sodium_per_100mg": 430.0, "default_serving_g": 100, "serving_description": "4 pieces"},
#     {"name": "Tilapia (cooked)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 128, "protein_per_100g": 26.2, "carbs_per_100g": 0.0, "fat_per_100g": 2.7, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 52.0, "default_serving_g": 150, "serving_description": "1 fillet"},
#     {"name": "Fish Curry (Indian)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 120, "protein_per_100g": 14.0, "carbs_per_100g": 4.0, "fat_per_100g": 5.5, "fiber_per_100g": 0.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 350.0, "default_serving_g": 200, "serving_description": "1 katori curry"},

#     # ── Vegetables ───────────────────────────────────────────────────────────
#     {"name": "Spinach / Palak (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 23, "protein_per_100g": 2.9, "carbs_per_100g": 3.6, "fat_per_100g": 0.4, "fiber_per_100g": 2.2, "sugar_per_100g": 0.4, "sodium_per_100mg": 79.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Potato (boiled)", "brand": None, "category": "Vegetables", "calories_per_100g": 77, "protein_per_100g": 2.0, "carbs_per_100g": 17.0, "fat_per_100g": 0.1, "fiber_per_100g": 1.8, "sugar_per_100g": 0.9, "sodium_per_100mg": 4.0, "default_serving_g": 150, "serving_description": "1 medium potato"},
#     {"name": "Sweet Potato / Shakarkandi (boiled)", "brand": None, "category": "Vegetables", "calories_per_100g": 86, "protein_per_100g": 1.6, "carbs_per_100g": 20.1, "fat_per_100g": 0.1, "fiber_per_100g": 3.0, "sugar_per_100g": 4.2, "sodium_per_100mg": 55.0, "default_serving_g": 150, "serving_description": "1 medium"},
#     {"name": "Tomato (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 18, "protein_per_100g": 0.9, "carbs_per_100g": 3.9, "fat_per_100g": 0.2, "fiber_per_100g": 1.2, "sugar_per_100g": 2.6, "sodium_per_100mg": 5.0, "default_serving_g": 100, "serving_description": "1 medium tomato"},
#     {"name": "Onion (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 40, "protein_per_100g": 1.1, "carbs_per_100g": 9.3, "fat_per_100g": 0.1, "fiber_per_100g": 1.7, "sugar_per_100g": 4.2, "sodium_per_100mg": 4.0, "default_serving_g": 100, "serving_description": "1 medium onion"},
#     {"name": "Cauliflower / Gobhi", "brand": None, "category": "Vegetables", "calories_per_100g": 25, "protein_per_100g": 1.9, "carbs_per_100g": 5.0, "fat_per_100g": 0.3, "fiber_per_100g": 2.0, "sugar_per_100g": 1.9, "sodium_per_100mg": 30.0, "default_serving_g": 100, "serving_description": "100g florets"},
#     {"name": "Broccoli", "brand": None, "category": "Vegetables", "calories_per_100g": 34, "protein_per_100g": 2.8, "carbs_per_100g": 6.6, "fat_per_100g": 0.4, "fiber_per_100g": 2.6, "sugar_per_100g": 1.7, "sodium_per_100mg": 33.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Cabbage / Patta Gobhi", "brand": None, "category": "Vegetables", "calories_per_100g": 25, "protein_per_100g": 1.3, "carbs_per_100g": 5.8, "fat_per_100g": 0.1, "fiber_per_100g": 2.5, "sugar_per_100g": 3.2, "sodium_per_100mg": 18.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Carrot / Gajar (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 41, "protein_per_100g": 0.9, "carbs_per_100g": 9.6, "fat_per_100g": 0.2, "fiber_per_100g": 2.8, "sugar_per_100g": 4.7, "sodium_per_100mg": 69.0, "default_serving_g": 100, "serving_description": "1 medium carrot"},
#     {"name": "Beetroot / Chukandar (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 43, "protein_per_100g": 1.6, "carbs_per_100g": 9.6, "fat_per_100g": 0.2, "fiber_per_100g": 2.8, "sugar_per_100g": 6.8, "sodium_per_100mg": 78.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Peas / Matar (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 81, "protein_per_100g": 5.4, "carbs_per_100g": 14.5, "fat_per_100g": 0.4, "fiber_per_100g": 5.1, "sugar_per_100g": 5.7, "sodium_per_100mg": 5.0, "default_serving_g": 80, "serving_description": "1/2 katori"},
#     {"name": "French Beans (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 31, "protein_per_100g": 1.8, "carbs_per_100g": 7.1, "fat_per_100g": 0.1, "fiber_per_100g": 2.7, "sugar_per_100g": 1.4, "sodium_per_100mg": 6.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Okra / Bhindi (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 33, "protein_per_100g": 1.9, "carbs_per_100g": 7.4, "fat_per_100g": 0.2, "fiber_per_100g": 3.2, "sugar_per_100g": 1.5, "sodium_per_100mg": 7.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Brinjal / Baingan (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 25, "protein_per_100g": 1.0, "carbs_per_100g": 5.7, "fat_per_100g": 0.2, "fiber_per_100g": 2.5, "sugar_per_100g": 2.4, "sodium_per_100mg": 2.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Bottle Gourd / Lauki (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 14, "protein_per_100g": 0.6, "carbs_per_100g": 3.4, "fat_per_100g": 0.0, "fiber_per_100g": 0.5, "sugar_per_100g": 1.5, "sodium_per_100mg": 2.0, "default_serving_g": 150, "serving_description": "1 katori cooked"},
#     {"name": "Bitter Gourd / Karela (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 17, "protein_per_100g": 1.0, "carbs_per_100g": 3.7, "fat_per_100g": 0.2, "fiber_per_100g": 2.8, "sugar_per_100g": 1.7, "sodium_per_100mg": 5.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Capsicum / Bell Pepper (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 20, "protein_per_100g": 0.9, "carbs_per_100g": 4.6, "fat_per_100g": 0.2, "fiber_per_100g": 1.7, "sugar_per_100g": 2.4, "sodium_per_100mg": 4.0, "default_serving_g": 100, "serving_description": "1 medium pepper"},
#     {"name": "Cucumber (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 15, "protein_per_100g": 0.7, "carbs_per_100g": 3.6, "fat_per_100g": 0.1, "fiber_per_100g": 0.5, "sugar_per_100g": 1.7, "sodium_per_100mg": 2.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Mushroom (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 22, "protein_per_100g": 3.1, "carbs_per_100g": 3.3, "fat_per_100g": 0.4, "fiber_per_100g": 1.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 9.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Drumstick / Moringa (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 26, "protein_per_100g": 2.1, "carbs_per_100g": 3.7, "fat_per_100g": 0.2, "fiber_per_100g": 2.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 42.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Radish / Mooli (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 16, "protein_per_100g": 0.7, "carbs_per_100g": 3.4, "fat_per_100g": 0.1, "fiber_per_100g": 1.6, "sugar_per_100g": 1.9, "sodium_per_100mg": 39.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Colocasia / Arbi (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 97, "protein_per_100g": 1.5, "carbs_per_100g": 23.0, "fat_per_100g": 0.1, "fiber_per_100g": 4.1, "sugar_per_100g": 0.5, "sodium_per_100mg": 11.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Ridge Gourd / Turai (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 18, "protein_per_100g": 0.5, "carbs_per_100g": 3.6, "fat_per_100g": 0.2, "fiber_per_100g": 0.5, "sugar_per_100g": 1.5, "sodium_per_100mg": 3.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Pumpkin / Kaddu (cooked)", "brand": None, "category": "Vegetables", "calories_per_100g": 20, "protein_per_100g": 0.7, "carbs_per_100g": 4.9, "fat_per_100g": 0.1, "fiber_per_100g": 0.5, "sugar_per_100g": 2.1, "sodium_per_100mg": 1.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Garlic (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 149, "protein_per_100g": 6.4, "carbs_per_100g": 33.1, "fat_per_100g": 0.5, "fiber_per_100g": 2.1, "sugar_per_100g": 1.0, "sodium_per_100mg": 17.0, "default_serving_g": 10, "serving_description": "2-3 cloves"},
#     {"name": "Ginger (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 80, "protein_per_100g": 1.8, "carbs_per_100g": 17.8, "fat_per_100g": 0.8, "fiber_per_100g": 2.0, "sugar_per_100g": 1.7, "sodium_per_100mg": 13.0, "default_serving_g": 10, "serving_description": "1 tsp grated"},
#     {"name": "Green Chilli (raw)", "brand": None, "category": "Vegetables", "calories_per_100g": 40, "protein_per_100g": 2.0, "carbs_per_100g": 9.5, "fat_per_100g": 0.2, "fiber_per_100g": 1.5, "sugar_per_100g": 5.1, "sodium_per_100mg": 7.0, "default_serving_g": 10, "serving_description": "1-2 chillis"},

#     # Indian vegetable dishes (cooked sabzis)
#     {"name": "Aloo Gobi (dry)", "brand": None, "category": "Vegetables", "calories_per_100g": 95, "protein_per_100g": 2.5, "carbs_per_100g": 12.0, "fat_per_100g": 4.5, "fiber_per_100g": 2.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 280.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Baingan Bharta", "brand": None, "category": "Vegetables", "calories_per_100g": 85, "protein_per_100g": 2.0, "carbs_per_100g": 8.0, "fat_per_100g": 5.5, "fiber_per_100g": 2.5, "sugar_per_100g": 3.0, "sodium_per_100mg": 300.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Bhindi Fry / Okra Stir Fry", "brand": None, "category": "Vegetables", "calories_per_100g": 105, "protein_per_100g": 2.5, "carbs_per_100g": 8.0, "fat_per_100g": 7.5, "fiber_per_100g": 3.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 250.0, "default_serving_g": 120, "serving_description": "1 katori"},
#     {"name": "Palak Paneer", "brand": None, "category": "Vegetables", "calories_per_100g": 145, "protein_per_100g": 8.0, "carbs_per_100g": 5.0, "fat_per_100g": 11.0, "fiber_per_100g": 1.5, "sugar_per_100g": 1.5, "sodium_per_100mg": 350.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Matar Paneer", "brand": None, "category": "Vegetables", "calories_per_100g": 155, "protein_per_100g": 8.5, "carbs_per_100g": 7.0, "fat_per_100g": 11.0, "fiber_per_100g": 2.0, "sugar_per_100g": 2.5, "sodium_per_100mg": 360.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Mixed Veg Curry", "brand": None, "category": "Vegetables", "calories_per_100g": 90, "protein_per_100g": 2.5, "carbs_per_100g": 9.0, "fat_per_100g": 5.0, "fiber_per_100g": 2.5, "sugar_per_100g": 2.5, "sodium_per_100mg": 300.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Lauki Sabzi", "brand": None, "category": "Vegetables", "calories_per_100g": 52, "protein_per_100g": 1.5, "carbs_per_100g": 5.5, "fat_per_100g": 3.0, "fiber_per_100g": 1.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 250.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Tinda Sabzi", "brand": None, "category": "Vegetables", "calories_per_100g": 55, "protein_per_100g": 1.2, "carbs_per_100g": 6.0, "fat_per_100g": 3.0, "fiber_per_100g": 1.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 240.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Aloo Matar (dry)", "brand": None, "category": "Vegetables", "calories_per_100g": 105, "protein_per_100g": 3.0, "carbs_per_100g": 14.0, "fat_per_100g": 4.5, "fiber_per_100g": 2.5, "sugar_per_100g": 2.5, "sodium_per_100mg": 300.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Sarson ka Saag", "brand": None, "category": "Vegetables", "calories_per_100g": 80, "protein_per_100g": 3.0, "carbs_per_100g": 6.0, "fat_per_100g": 5.0, "fiber_per_100g": 2.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 300.0, "default_serving_g": 150, "serving_description": "1 katori"},

#     # ── Fruits ───────────────────────────────────────────────────────────────
#     {"name": "Banana (ripe)", "brand": None, "category": "Fruits", "calories_per_100g": 89, "protein_per_100g": 1.1, "carbs_per_100g": 23.0, "fat_per_100g": 0.3, "fiber_per_100g": 2.6, "sugar_per_100g": 12.2, "sodium_per_100mg": 1.0, "default_serving_g": 120, "serving_description": "1 medium banana"},
#     {"name": "Apple", "brand": None, "category": "Fruits", "calories_per_100g": 52, "protein_per_100g": 0.3, "carbs_per_100g": 13.8, "fat_per_100g": 0.2, "fiber_per_100g": 2.4, "sugar_per_100g": 10.4, "sodium_per_100mg": 1.0, "default_serving_g": 182, "serving_description": "1 medium apple"},
#     {"name": "Mango (Alphonso)", "brand": None, "category": "Fruits", "calories_per_100g": 60, "protein_per_100g": 0.8, "carbs_per_100g": 15.0, "fat_per_100g": 0.4, "fiber_per_100g": 1.6, "sugar_per_100g": 13.7, "sodium_per_100mg": 1.0, "default_serving_g": 150, "serving_description": "1 cup sliced"},
#     {"name": "Papaya (ripe)", "brand": None, "category": "Fruits", "calories_per_100g": 43, "protein_per_100g": 0.5, "carbs_per_100g": 11.0, "fat_per_100g": 0.3, "fiber_per_100g": 1.7, "sugar_per_100g": 7.8, "sodium_per_100mg": 8.0, "default_serving_g": 150, "serving_description": "1 cup cubed"},
#     {"name": "Guava / Amrood", "brand": None, "category": "Fruits", "calories_per_100g": 68, "protein_per_100g": 2.6, "carbs_per_100g": 14.3, "fat_per_100g": 1.0, "fiber_per_100g": 5.4, "sugar_per_100g": 8.9, "sodium_per_100mg": 2.0, "default_serving_g": 100, "serving_description": "1 small guava"},
#     {"name": "Pomegranate / Anar", "brand": None, "category": "Fruits", "calories_per_100g": 83, "protein_per_100g": 1.7, "carbs_per_100g": 18.7, "fat_per_100g": 1.2, "fiber_per_100g": 4.0, "sugar_per_100g": 13.7, "sodium_per_100mg": 3.0, "default_serving_g": 100, "serving_description": "1/2 pomegranate"},
#     {"name": "Watermelon", "brand": None, "category": "Fruits", "calories_per_100g": 30, "protein_per_100g": 0.6, "carbs_per_100g": 7.6, "fat_per_100g": 0.2, "fiber_per_100g": 0.4, "sugar_per_100g": 6.2, "sodium_per_100mg": 1.0, "default_serving_g": 300, "serving_description": "2 cups cubed"},
#     {"name": "Grapes (green)", "brand": None, "category": "Fruits", "calories_per_100g": 67, "protein_per_100g": 0.6, "carbs_per_100g": 17.2, "fat_per_100g": 0.4, "fiber_per_100g": 0.9, "sugar_per_100g": 16.3, "sodium_per_100mg": 2.0, "default_serving_g": 150, "serving_description": "1 small bunch"},
#     {"name": "Orange", "brand": None, "category": "Fruits", "calories_per_100g": 47, "protein_per_100g": 0.9, "carbs_per_100g": 11.8, "fat_per_100g": 0.1, "fiber_per_100g": 2.4, "sugar_per_100g": 9.4, "sodium_per_100mg": 0.0, "default_serving_g": 180, "serving_description": "1 medium orange"},
#     {"name": "Pineapple", "brand": None, "category": "Fruits", "calories_per_100g": 50, "protein_per_100g": 0.5, "carbs_per_100g": 13.1, "fat_per_100g": 0.1, "fiber_per_100g": 1.4, "sugar_per_100g": 9.9, "sodium_per_100mg": 1.0, "default_serving_g": 150, "serving_description": "1 cup chunks"},
#     {"name": "Chikoo / Sapota", "brand": None, "category": "Fruits", "calories_per_100g": 83, "protein_per_100g": 0.4, "carbs_per_100g": 19.9, "fat_per_100g": 1.1, "fiber_per_100g": 5.3, "sugar_per_100g": 16.1, "sodium_per_100mg": 12.0, "default_serving_g": 100, "serving_description": "1 medium"},
#     {"name": "Jackfruit / Kathal (raw)", "brand": None, "category": "Fruits", "calories_per_100g": 95, "protein_per_100g": 1.7, "carbs_per_100g": 23.2, "fat_per_100g": 0.6, "fiber_per_100g": 1.5, "sugar_per_100g": 19.1, "sodium_per_100mg": 2.0, "default_serving_g": 150, "serving_description": "1 cup pieces"},
#     {"name": "Litchi", "brand": None, "category": "Fruits", "calories_per_100g": 66, "protein_per_100g": 0.8, "carbs_per_100g": 16.5, "fat_per_100g": 0.4, "fiber_per_100g": 1.3, "sugar_per_100g": 15.2, "sodium_per_100mg": 1.0, "default_serving_g": 100, "serving_description": "8-10 litchis"},
#     {"name": "Pear / Nashpati", "brand": None, "category": "Fruits", "calories_per_100g": 57, "protein_per_100g": 0.4, "carbs_per_100g": 15.2, "fat_per_100g": 0.1, "fiber_per_100g": 3.1, "sugar_per_100g": 9.8, "sodium_per_100mg": 1.0, "default_serving_g": 178, "serving_description": "1 medium pear"},
#     {"name": "Dates / Khajoor (dried)", "brand": None, "category": "Fruits", "calories_per_100g": 277, "protein_per_100g": 1.8, "carbs_per_100g": 75.0, "fat_per_100g": 0.2, "fiber_per_100g": 6.7, "sugar_per_100g": 63.4, "sodium_per_100mg": 1.0, "default_serving_g": 30, "serving_description": "3-4 dates"},
#     {"name": "Raisins / Kishmish", "brand": None, "category": "Fruits", "calories_per_100g": 299, "protein_per_100g": 3.1, "carbs_per_100g": 79.2, "fat_per_100g": 0.5, "fiber_per_100g": 3.7, "sugar_per_100g": 59.2, "sodium_per_100mg": 11.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Coconut (fresh)", "brand": None, "category": "Fruits", "calories_per_100g": 354, "protein_per_100g": 3.3, "carbs_per_100g": 15.2, "fat_per_100g": 33.5, "fiber_per_100g": 9.0, "sugar_per_100g": 6.2, "sodium_per_100mg": 20.0, "default_serving_g": 30, "serving_description": "2 tbsp grated"},
#     {"name": "Strawberry", "brand": None, "category": "Fruits", "calories_per_100g": 32, "protein_per_100g": 0.7, "carbs_per_100g": 7.7, "fat_per_100g": 0.3, "fiber_per_100g": 2.0, "sugar_per_100g": 4.9, "sodium_per_100mg": 1.0, "default_serving_g": 150, "serving_description": "1 cup"},
#     {"name": "Kiwi", "brand": None, "category": "Fruits", "calories_per_100g": 61, "protein_per_100g": 1.1, "carbs_per_100g": 14.7, "fat_per_100g": 0.5, "fiber_per_100g": 3.0, "sugar_per_100g": 9.0, "sodium_per_100mg": 3.0, "default_serving_g": 75, "serving_description": "1 medium kiwi"},
#     {"name": "Plum / Aloo Bukhara", "brand": None, "category": "Fruits", "calories_per_100g": 46, "protein_per_100g": 0.7, "carbs_per_100g": 11.4, "fat_per_100g": 0.3, "fiber_per_100g": 1.4, "sugar_per_100g": 9.9, "sodium_per_100mg": 0.0, "default_serving_g": 66, "serving_description": "1 medium plum"},
#     {"name": "Avocado", "brand": None, "category": "Fruits", "calories_per_100g": 160, "protein_per_100g": 2.0, "carbs_per_100g": 8.5, "fat_per_100g": 14.7, "fiber_per_100g": 6.7, "sugar_per_100g": 0.7, "sodium_per_100mg": 7.0, "default_serving_g": 100, "serving_description": "1/2 avocado"},

#     # ── Legumes / Pulses ─────────────────────────────────────────────────────
#     {"name": "Toor Dal (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 116, "protein_per_100g": 6.8, "carbs_per_100g": 20.0, "fat_per_100g": 0.4, "fiber_per_100g": 5.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 5.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Moong Dal (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 105, "protein_per_100g": 7.0, "carbs_per_100g": 18.9, "fat_per_100g": 0.4, "fiber_per_100g": 7.6, "sugar_per_100g": 2.0, "sodium_per_100mg": 4.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Masoor Dal (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 116, "protein_per_100g": 9.0, "carbs_per_100g": 20.1, "fat_per_100g": 0.4, "fiber_per_100g": 7.9, "sugar_per_100g": 1.8, "sodium_per_100mg": 2.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Urad Dal (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 127, "protein_per_100g": 9.3, "carbs_per_100g": 22.0, "fat_per_100g": 0.6, "fiber_per_100g": 6.4, "sugar_per_100g": 1.5, "sodium_per_100mg": 4.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Chana Dal (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 164, "protein_per_100g": 8.9, "carbs_per_100g": 27.5, "fat_per_100g": 2.7, "fiber_per_100g": 10.8, "sugar_per_100g": 4.8, "sodium_per_100mg": 7.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Rajma / Kidney Beans (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 127, "protein_per_100g": 8.7, "carbs_per_100g": 22.8, "fat_per_100g": 0.5, "fiber_per_100g": 6.4, "sugar_per_100g": 0.3, "sodium_per_100mg": 2.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Chole / Chickpeas (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 164, "protein_per_100g": 8.9, "carbs_per_100g": 27.4, "fat_per_100g": 2.6, "fiber_per_100g": 7.6, "sugar_per_100g": 4.8, "sodium_per_100mg": 7.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Black Chana (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 164, "protein_per_100g": 8.9, "carbs_per_100g": 27.5, "fat_per_100g": 2.6, "fiber_per_100g": 7.6, "sugar_per_100g": 4.8, "sodium_per_100mg": 7.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Lobia / Black-eyed Peas (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 116, "protein_per_100g": 7.7, "carbs_per_100g": 20.8, "fat_per_100g": 0.5, "fiber_per_100g": 6.5, "sugar_per_100g": 3.0, "sodium_per_100mg": 4.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Whole Moong (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 105, "protein_per_100g": 7.0, "carbs_per_100g": 19.2, "fat_per_100g": 0.4, "fiber_per_100g": 7.6, "sugar_per_100g": 2.0, "sodium_per_100mg": 4.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Moth Dal (cooked)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 143, "protein_per_100g": 9.3, "carbs_per_100g": 26.1, "fat_per_100g": 0.5, "fiber_per_100g": 8.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 5.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Soya Chunks (dry)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 345, "protein_per_100g": 52.4, "carbs_per_100g": 33.0, "fat_per_100g": 0.5, "fiber_per_100g": 13.0, "sugar_per_100g": 6.0, "sodium_per_100mg": 20.0, "default_serving_g": 50, "serving_description": "50g dry"},
#     {"name": "Tofu (firm)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 76, "protein_per_100g": 8.0, "carbs_per_100g": 1.9, "fat_per_100g": 4.8, "fiber_per_100g": 0.3, "sugar_per_100g": 0.6, "sodium_per_100mg": 7.0, "default_serving_g": 100, "serving_description": "100g"},
#     {"name": "Peanuts (roasted)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 567, "protein_per_100g": 25.8, "carbs_per_100g": 16.1, "fat_per_100g": 49.2, "fiber_per_100g": 8.5, "sugar_per_100g": 4.7, "sodium_per_100mg": 6.0, "default_serving_g": 30, "serving_description": "small handful"},
#     {"name": "Besan / Chickpea Flour (raw)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 387, "protein_per_100g": 22.4, "carbs_per_100g": 57.8, "fat_per_100g": 6.7, "fiber_per_100g": 10.9, "sugar_per_100g": 10.9, "sodium_per_100mg": 64.0, "default_serving_g": 30, "serving_description": "30g"},

#     # Indian dal preparations and curries
#     {"name": "Dal Tadka (yellow dal)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 100, "protein_per_100g": 5.5, "carbs_per_100g": 14.0, "fat_per_100g": 3.0, "fiber_per_100g": 3.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 350.0, "default_serving_g": 200, "serving_description": "1 katori"},
#     {"name": "Dal Makhani", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 130, "protein_per_100g": 5.5, "carbs_per_100g": 14.0, "fat_per_100g": 6.0, "fiber_per_100g": 3.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 380.0, "default_serving_g": 200, "serving_description": "1 katori"},
#     {"name": "Dal Fry", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 95, "protein_per_100g": 5.0, "carbs_per_100g": 13.0, "fat_per_100g": 3.0, "fiber_per_100g": 3.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 340.0, "default_serving_g": 200, "serving_description": "1 katori"},
#     {"name": "Kadhi (besan-curd curry)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 70, "protein_per_100g": 2.5, "carbs_per_100g": 6.0, "fat_per_100g": 4.0, "fiber_per_100g": 0.5, "sugar_per_100g": 2.0, "sodium_per_100mg": 300.0, "default_serving_g": 200, "serving_description": "1 katori"},
#     {"name": "Sambar", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 65, "protein_per_100g": 3.5, "carbs_per_100g": 9.0, "fat_per_100g": 2.0, "fiber_per_100g": 2.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 350.0, "default_serving_g": 200, "serving_description": "1 katori"},
#     {"name": "Rasam", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 28, "protein_per_100g": 1.0, "carbs_per_100g": 4.5, "fat_per_100g": 0.5, "fiber_per_100g": 0.5, "sugar_per_100g": 1.5, "sodium_per_100mg": 400.0, "default_serving_g": 200, "serving_description": "1 katori"},
#     {"name": "Rajma Curry", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 115, "protein_per_100g": 6.0, "carbs_per_100g": 15.0, "fat_per_100g": 4.0, "fiber_per_100g": 4.5, "sugar_per_100g": 1.5, "sodium_per_100mg": 380.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Chole Curry / Chana Masala", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 140, "protein_per_100g": 7.0, "carbs_per_100g": 18.0, "fat_per_100g": 5.0, "fiber_per_100g": 5.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 400.0, "default_serving_g": 200, "serving_description": "1 katori curry"},
#     {"name": "Sprouted Moong Salad", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 60, "protein_per_100g": 5.0, "carbs_per_100g": 8.5, "fat_per_100g": 0.5, "fiber_per_100g": 3.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 120.0, "default_serving_g": 100, "serving_description": "1 small katori"},

#     # ── Nuts / Seeds ─────────────────────────────────────────────────────────
#     {"name": "Almonds", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 579, "protein_per_100g": 21.2, "carbs_per_100g": 21.6, "fat_per_100g": 49.9, "fiber_per_100g": 12.5, "sugar_per_100g": 4.4, "sodium_per_100mg": 1.0, "default_serving_g": 28, "serving_description": "small handful (23 almonds)"},
#     {"name": "Cashews", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 553, "protein_per_100g": 18.2, "carbs_per_100g": 30.2, "fat_per_100g": 43.9, "fiber_per_100g": 3.3, "sugar_per_100g": 5.9, "sodium_per_100mg": 12.0, "default_serving_g": 28, "serving_description": "small handful"},
#     {"name": "Walnuts", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 654, "protein_per_100g": 15.2, "carbs_per_100g": 13.7, "fat_per_100g": 65.2, "fiber_per_100g": 6.7, "sugar_per_100g": 2.6, "sodium_per_100mg": 2.0, "default_serving_g": 28, "serving_description": "small handful"},
#     {"name": "Pistachios", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 562, "protein_per_100g": 20.3, "carbs_per_100g": 27.5, "fat_per_100g": 45.4, "fiber_per_100g": 10.3, "sugar_per_100g": 7.7, "sodium_per_100mg": 1.0, "default_serving_g": 28, "serving_description": "small handful"},
#     {"name": "Sunflower Seeds", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 584, "protein_per_100g": 20.8, "carbs_per_100g": 20.0, "fat_per_100g": 51.5, "fiber_per_100g": 8.6, "sugar_per_100g": 2.6, "sodium_per_100mg": 9.0, "default_serving_g": 28, "serving_description": "2 tbsp"},
#     {"name": "Pumpkin Seeds / Kaddu Beej", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 559, "protein_per_100g": 30.2, "carbs_per_100g": 10.7, "fat_per_100g": 49.1, "fiber_per_100g": 6.0, "sugar_per_100g": 1.4, "sodium_per_100mg": 7.0, "default_serving_g": 28, "serving_description": "2 tbsp"},
#     {"name": "Flaxseeds / Alsi", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 534, "protein_per_100g": 18.3, "carbs_per_100g": 28.9, "fat_per_100g": 42.2, "fiber_per_100g": 27.3, "sugar_per_100g": 1.6, "sodium_per_100mg": 30.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Chia Seeds", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 486, "protein_per_100g": 16.5, "carbs_per_100g": 42.1, "fat_per_100g": 30.7, "fiber_per_100g": 34.4, "sugar_per_100g": 0.0, "sodium_per_100mg": 16.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Sesame Seeds / Til", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 573, "protein_per_100g": 17.7, "carbs_per_100g": 23.5, "fat_per_100g": 49.7, "fiber_per_100g": 11.8, "sugar_per_100g": 0.3, "sodium_per_100mg": 11.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Coconut (desiccated)", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 660, "protein_per_100g": 7.2, "carbs_per_100g": 23.7, "fat_per_100g": 64.5, "fiber_per_100g": 16.3, "sugar_per_100g": 7.5, "sodium_per_100mg": 37.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Peanut Butter (natural)", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 588, "protein_per_100g": 25.1, "carbs_per_100g": 20.1, "fat_per_100g": 50.4, "fiber_per_100g": 5.9, "sugar_per_100g": 9.2, "sodium_per_100mg": 17.0, "default_serving_g": 32, "serving_description": "2 tbsp"},
#     {"name": "Melon Seeds / Magaz", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 557, "protein_per_100g": 28.8, "carbs_per_100g": 15.3, "fat_per_100g": 47.4, "fiber_per_100g": 4.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 10.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Poppy Seeds / Khus Khus", "brand": None, "category": "Nuts/Seeds", "calories_per_100g": 525, "protein_per_100g": 17.9, "carbs_per_100g": 28.1, "fat_per_100g": 41.6, "fiber_per_100g": 19.5, "sugar_per_100g": 2.9, "sodium_per_100mg": 26.0, "default_serving_g": 10, "serving_description": "1 tsp"},

#     # ── Beverages ────────────────────────────────────────────────────────────
#     {"name": "Chai (with milk and sugar)", "brand": None, "category": "Beverages", "calories_per_100g": 44, "protein_per_100g": 1.4, "carbs_per_100g": 7.0, "fat_per_100g": 1.3, "fiber_per_100g": 0.0, "sugar_per_100g": 6.5, "sodium_per_100mg": 20.0, "default_serving_g": 150, "serving_description": "1 cup tea"},
#     {"name": "Black Coffee (unsweetened)", "brand": None, "category": "Beverages", "calories_per_100g": 2, "protein_per_100g": 0.3, "carbs_per_100g": 0.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 5.0, "default_serving_g": 240, "serving_description": "1 mug"},
#     {"name": "Coconut Water", "brand": None, "category": "Beverages", "calories_per_100g": 19, "protein_per_100g": 0.7, "carbs_per_100g": 3.7, "fat_per_100g": 0.2, "fiber_per_100g": 1.1, "sugar_per_100g": 2.6, "sodium_per_100mg": 105.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Orange Juice (fresh)", "brand": None, "category": "Beverages", "calories_per_100g": 45, "protein_per_100g": 0.7, "carbs_per_100g": 10.4, "fat_per_100g": 0.2, "fiber_per_100g": 0.2, "sugar_per_100g": 8.4, "sodium_per_100mg": 1.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Mango Lassi", "brand": None, "category": "Beverages", "calories_per_100g": 88, "protein_per_100g": 2.8, "carbs_per_100g": 15.5, "fat_per_100g": 2.0, "fiber_per_100g": 0.3, "sugar_per_100g": 14.5, "sodium_per_100mg": 40.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Buttermilk / Chaas (plain)", "brand": None, "category": "Beverages", "calories_per_100g": 40, "protein_per_100g": 3.3, "carbs_per_100g": 4.8, "fat_per_100g": 0.9, "fiber_per_100g": 0.0, "sugar_per_100g": 4.8, "sodium_per_100mg": 105.0, "default_serving_g": 200, "serving_description": "1 glass"},
#     {"name": "Sugarcane Juice", "brand": None, "category": "Beverages", "calories_per_100g": 45, "protein_per_100g": 0.1, "carbs_per_100g": 11.2, "fat_per_100g": 0.2, "fiber_per_100g": 0.6, "sugar_per_100g": 9.9, "sodium_per_100mg": 1.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Lemon Water (with sugar)", "brand": None, "category": "Beverages", "calories_per_100g": 22, "protein_per_100g": 0.1, "carbs_per_100g": 5.6, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 5.5, "sodium_per_100mg": 1.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Whole Milk", "brand": None, "category": "Beverages", "calories_per_100g": 61, "protein_per_100g": 3.2, "carbs_per_100g": 4.7, "fat_per_100g": 3.3, "fiber_per_100g": 0.0, "sugar_per_100g": 4.7, "sodium_per_100mg": 44.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Soft Drink / Cola", "brand": None, "category": "Beverages", "calories_per_100g": 41, "protein_per_100g": 0.0, "carbs_per_100g": 10.6, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 10.6, "sodium_per_100mg": 10.0, "default_serving_g": 355, "serving_description": "1 can"},
#     {"name": "Beer", "brand": None, "category": "Beverages", "calories_per_100g": 43, "protein_per_100g": 0.5, "carbs_per_100g": 3.6, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 14.0, "default_serving_g": 355, "serving_description": "1 can"},
#     {"name": "Protein Shake (whey, mixed)", "brand": None, "category": "Beverages", "calories_per_100g": 113, "protein_per_100g": 14.8, "carbs_per_100g": 10.2, "fat_per_100g": 2.0, "fiber_per_100g": 0.5, "sugar_per_100g": 7.0, "sodium_per_100mg": 120.0, "default_serving_g": 300, "serving_description": "1 shake"},
#     {"name": "Green Tea (plain)", "brand": None, "category": "Beverages", "calories_per_100g": 1, "protein_per_100g": 0.2, "carbs_per_100g": 0.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 240, "serving_description": "1 cup"},
#     {"name": "Nimbu Pani (salted)", "brand": None, "category": "Beverages", "calories_per_100g": 12, "protein_per_100g": 0.1, "carbs_per_100g": 2.8, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 500.0, "default_serving_g": 240, "serving_description": "1 glass"},
#     {"name": "Sweet Lassi", "brand": None, "category": "Beverages", "calories_per_100g": 75, "protein_per_100g": 2.8, "carbs_per_100g": 12.0, "fat_per_100g": 2.0, "fiber_per_100g": 0.0, "sugar_per_100g": 11.0, "sodium_per_100mg": 40.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Salt Lassi / Salted Lassi", "brand": None, "category": "Beverages", "calories_per_100g": 48, "protein_per_100g": 3.0, "carbs_per_100g": 4.5, "fat_per_100g": 2.0, "fiber_per_100g": 0.0, "sugar_per_100g": 4.5, "sodium_per_100mg": 250.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Aam Panna", "brand": None, "category": "Beverages", "calories_per_100g": 35, "protein_per_100g": 0.2, "carbs_per_100g": 8.5, "fat_per_100g": 0.1, "fiber_per_100g": 0.3, "sugar_per_100g": 7.0, "sodium_per_100mg": 150.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Jaljeera", "brand": None, "category": "Beverages", "calories_per_100g": 18, "protein_per_100g": 0.3, "carbs_per_100g": 4.0, "fat_per_100g": 0.1, "fiber_per_100g": 0.2, "sugar_per_100g": 2.5, "sodium_per_100mg": 450.0, "default_serving_g": 250, "serving_description": "1 glass"},

#     # ── Snacks ───────────────────────────────────────────────────────────────
#     {"name": "Roasted Makhana / Fox Nuts", "brand": None, "category": "Snacks", "calories_per_100g": 347, "protein_per_100g": 9.7, "carbs_per_100g": 76.9, "fat_per_100g": 0.1, "fiber_per_100g": 14.5, "sugar_per_100g": 0.0, "sodium_per_100mg": 1.0, "default_serving_g": 30, "serving_description": "1 cup"},
#     {"name": "Rice Cakes (plain)", "brand": None, "category": "Snacks", "calories_per_100g": 387, "protein_per_100g": 8.2, "carbs_per_100g": 81.5, "fat_per_100g": 3.5, "fiber_per_100g": 3.5, "sugar_per_100g": 0.2, "sodium_per_100mg": 26.0, "default_serving_g": 30, "serving_description": "3 cakes"},
#     {"name": "Popcorn (plain, air-popped)", "brand": None, "category": "Snacks", "calories_per_100g": 375, "protein_per_100g": 11.0, "carbs_per_100g": 74.0, "fat_per_100g": 4.5, "fiber_per_100g": 14.5, "sugar_per_100g": 0.9, "sodium_per_100mg": 2.0, "default_serving_g": 30, "serving_description": "1 cup"},
#     {"name": "Bhujia (besan)", "brand": None, "category": "Snacks", "calories_per_100g": 481, "protein_per_100g": 12.0, "carbs_per_100g": 47.0, "fat_per_100g": 27.5, "fiber_per_100g": 5.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 600.0, "default_serving_g": 30, "serving_description": "small handful"},
#     {"name": "Chakli (rice flour)", "brand": None, "category": "Snacks", "calories_per_100g": 497, "protein_per_100g": 7.0, "carbs_per_100g": 54.0, "fat_per_100g": 28.0, "fiber_per_100g": 2.0, "sugar_per_100g": 0.5, "sodium_per_100mg": 400.0, "default_serving_g": 30, "serving_description": "2-3 pieces"},
#     {"name": "Murukku (rice-based)", "brand": None, "category": "Snacks", "calories_per_100g": 513, "protein_per_100g": 8.5, "carbs_per_100g": 55.0, "fat_per_100g": 29.0, "fiber_per_100g": 2.0, "sugar_per_100g": 0.3, "sodium_per_100mg": 380.0, "default_serving_g": 30, "serving_description": "2-3 pieces"},
#     {"name": "Besan Chilla (plain)", "brand": None, "category": "Snacks", "calories_per_100g": 180, "protein_per_100g": 9.0, "carbs_per_100g": 22.0, "fat_per_100g": 5.5, "fiber_per_100g": 4.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 200.0, "default_serving_g": 100, "serving_description": "1 medium chilla"},
#     {"name": "Samosa (veg)", "brand": None, "category": "Snacks", "calories_per_100g": 308, "protein_per_100g": 4.5, "carbs_per_100g": 35.0, "fat_per_100g": 16.5, "fiber_per_100g": 2.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 350.0, "default_serving_g": 80, "serving_description": "1 medium samosa"},
#     {"name": "Kachori", "brand": None, "category": "Snacks", "calories_per_100g": 422, "protein_per_100g": 8.0, "carbs_per_100g": 42.0, "fat_per_100g": 25.0, "fiber_per_100g": 3.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 300.0, "default_serving_g": 80, "serving_description": "1 kachori"},
#     {"name": "Potato Chips", "brand": None, "category": "Snacks", "calories_per_100g": 536, "protein_per_100g": 7.0, "carbs_per_100g": 53.0, "fat_per_100g": 34.6, "fiber_per_100g": 4.4, "sugar_per_100g": 0.4, "sodium_per_100mg": 525.0, "default_serving_g": 30, "serving_description": "small pack"},
#     {"name": "Namkeen / Mixture", "brand": None, "category": "Snacks", "calories_per_100g": 520, "protein_per_100g": 10.0, "carbs_per_100g": 50.0, "fat_per_100g": 31.0, "fiber_per_100g": 4.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 600.0, "default_serving_g": 30, "serving_description": "small handful"},
#     {"name": "Digestive Biscuit", "brand": None, "category": "Snacks", "calories_per_100g": 480, "protein_per_100g": 7.0, "carbs_per_100g": 64.0, "fat_per_100g": 22.0, "fiber_per_100g": 3.5, "sugar_per_100g": 16.5, "sodium_per_100mg": 355.0, "default_serving_g": 30, "serving_description": "2 biscuits"},
#     {"name": "Energy Bar", "brand": None, "category": "Snacks", "calories_per_100g": 380, "protein_per_100g": 8.0, "carbs_per_100g": 60.0, "fat_per_100g": 12.0, "fiber_per_100g": 4.0, "sugar_per_100g": 28.0, "sodium_per_100mg": 120.0, "default_serving_g": 50, "serving_description": "1 bar"},
#     {"name": "Roasted Peanuts", "brand": None, "category": "Snacks", "calories_per_100g": 587, "protein_per_100g": 23.7, "carbs_per_100g": 21.5, "fat_per_100g": 49.6, "fiber_per_100g": 8.0, "sugar_per_100g": 4.0, "sodium_per_100mg": 230.0, "default_serving_g": 30, "serving_description": "small handful"},
#     {"name": "Sev (besan)", "brand": None, "category": "Snacks", "calories_per_100g": 545, "protein_per_100g": 14.0, "carbs_per_100g": 53.0, "fat_per_100g": 31.0, "fiber_per_100g": 5.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 400.0, "default_serving_g": 20, "serving_description": "small handful"},
#     {"name": "Dhokla", "brand": None, "category": "Snacks", "calories_per_100g": 160, "protein_per_100g": 7.0, "carbs_per_100g": 25.0, "fat_per_100g": 4.0, "fiber_per_100g": 2.5, "sugar_per_100g": 3.0, "sodium_per_100mg": 350.0, "default_serving_g": 100, "serving_description": "2 pieces"},
#     {"name": "Khandvi", "brand": None, "category": "Snacks", "calories_per_100g": 145, "protein_per_100g": 6.5, "carbs_per_100g": 18.0, "fat_per_100g": 5.5, "fiber_per_100g": 2.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 300.0, "default_serving_g": 80, "serving_description": "4-5 rolls"},
#     {"name": "Papad (roasted)", "brand": None, "category": "Snacks", "calories_per_100g": 320, "protein_per_100g": 22.0, "carbs_per_100g": 47.0, "fat_per_100g": 4.0, "fiber_per_100g": 6.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 1200.0, "default_serving_g": 15, "serving_description": "1 papad"},
#     {"name": "Papad (fried)", "brand": None, "category": "Snacks", "calories_per_100g": 470, "protein_per_100g": 20.0, "carbs_per_100g": 40.0, "fat_per_100g": 25.0, "fiber_per_100g": 5.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 1200.0, "default_serving_g": 15, "serving_description": "1 papad"},
#     {"name": "Roasted Chana", "brand": None, "category": "Snacks", "calories_per_100g": 369, "protein_per_100g": 22.0, "carbs_per_100g": 58.0, "fat_per_100g": 5.0, "fiber_per_100g": 17.0, "sugar_per_100g": 10.0, "sodium_per_100mg": 24.0, "default_serving_g": 30, "serving_description": "small handful"},
#     {"name": "Peanut Chikki", "brand": None, "category": "Snacks", "calories_per_100g": 450, "protein_per_100g": 13.0, "carbs_per_100g": 55.0, "fat_per_100g": 20.0, "fiber_per_100g": 3.0, "sugar_per_100g": 40.0, "sodium_per_100mg": 15.0, "default_serving_g": 30, "serving_description": "1 piece"},
#     {"name": "Til Chikki / Sesame Chikki", "brand": None, "category": "Snacks", "calories_per_100g": 460, "protein_per_100g": 10.0, "carbs_per_100g": 56.0, "fat_per_100g": 22.0, "fiber_per_100g": 4.0, "sugar_per_100g": 42.0, "sodium_per_100mg": 20.0, "default_serving_g": 30, "serving_description": "1 piece"},
#     {"name": "Khakhra (plain)", "brand": None, "category": "Snacks", "calories_per_100g": 420, "protein_per_100g": 12.0, "carbs_per_100g": 60.0, "fat_per_100g": 15.0, "fiber_per_100g": 5.0, "sugar_per_100g": 1.5, "sodium_per_100mg": 400.0, "default_serving_g": 25, "serving_description": "1 khakhra"},
#     {"name": "Sundal / Chana Sundal", "brand": None, "category": "Snacks", "calories_per_100g": 148, "protein_per_100g": 8.0, "carbs_per_100g": 22.0, "fat_per_100g": 3.5, "fiber_per_100g": 6.0, "sugar_per_100g": 3.0, "sodium_per_100mg": 200.0, "default_serving_g": 100, "serving_description": "1 small katori"},

#     # ── Sweets / Desserts ────────────────────────────────────────────────────
#     {"name": "Rasgulla", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 186, "protein_per_100g": 5.5, "carbs_per_100g": 39.0, "fat_per_100g": 1.3, "fiber_per_100g": 0.0, "sugar_per_100g": 33.0, "sodium_per_100mg": 20.0, "default_serving_g": 100, "serving_description": "2 medium pieces"},
#     {"name": "Kheer (rice)", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 152, "protein_per_100g": 4.2, "carbs_per_100g": 24.5, "fat_per_100g": 4.2, "fiber_per_100g": 0.2, "sugar_per_100g": 17.0, "sodium_per_100mg": 50.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Gulab Jamun", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 387, "protein_per_100g": 6.0, "carbs_per_100g": 58.0, "fat_per_100g": 15.0, "fiber_per_100g": 0.5, "sugar_per_100g": 47.0, "sodium_per_100mg": 100.0, "default_serving_g": 60, "serving_description": "2 pieces"},
#     {"name": "Jalebi", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 449, "protein_per_100g": 4.0, "carbs_per_100g": 75.0, "fat_per_100g": 16.0, "fiber_per_100g": 0.5, "sugar_per_100g": 57.0, "sodium_per_100mg": 30.0, "default_serving_g": 80, "serving_description": "2 medium jalebis"},
#     {"name": "Besan Ladoo", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 458, "protein_per_100g": 10.0, "carbs_per_100g": 58.0, "fat_per_100g": 22.0, "fiber_per_100g": 3.0, "sugar_per_100g": 35.0, "sodium_per_100mg": 20.0, "default_serving_g": 40, "serving_description": "1 ladoo"},
#     {"name": "Barfi (plain milk)", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 395, "protein_per_100g": 8.5, "carbs_per_100g": 60.0, "fat_per_100g": 14.0, "fiber_per_100g": 0.0, "sugar_per_100g": 55.0, "sodium_per_100mg": 60.0, "default_serving_g": 40, "serving_description": "1 piece"},
#     {"name": "Peda", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 420, "protein_per_100g": 8.0, "carbs_per_100g": 66.0, "fat_per_100g": 14.0, "fiber_per_100g": 0.0, "sugar_per_100g": 55.0, "sodium_per_100mg": 40.0, "default_serving_g": 40, "serving_description": "1 peda"},
#     {"name": "Gajar Halwa", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 196, "protein_per_100g": 3.8, "carbs_per_100g": 26.0, "fat_per_100g": 9.0, "fiber_per_100g": 1.5, "sugar_per_100g": 22.0, "sodium_per_100mg": 50.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Halwa (sooji / semolina)", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 311, "protein_per_100g": 4.5, "carbs_per_100g": 42.0, "fat_per_100g": 13.0, "fiber_per_100g": 1.0, "sugar_per_100g": 25.0, "sodium_per_100mg": 60.0, "default_serving_g": 150, "serving_description": "1 katori"},
#     {"name": "Rasmalai", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 195, "protein_per_100g": 6.5, "carbs_per_100g": 28.0, "fat_per_100g": 7.0, "fiber_per_100g": 0.0, "sugar_per_100g": 24.0, "sodium_per_100mg": 40.0, "default_serving_g": 100, "serving_description": "2 pieces"},
#     {"name": "Dark Chocolate (70%+)", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 546, "protein_per_100g": 5.5, "carbs_per_100g": 59.4, "fat_per_100g": 31.3, "fiber_per_100g": 10.9, "sugar_per_100g": 47.9, "sodium_per_100mg": 20.0, "default_serving_g": 30, "serving_description": "3 squares"},
#     {"name": "Ice Cream (vanilla)", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 207, "protein_per_100g": 3.5, "carbs_per_100g": 23.6, "fat_per_100g": 11.0, "fiber_per_100g": 0.6, "sugar_per_100g": 21.2, "sodium_per_100mg": 80.0, "default_serving_g": 100, "serving_description": "1 scoop"},
#     {"name": "Payasam / Semiya Kheer", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 187, "protein_per_100g": 4.5, "carbs_per_100g": 32.0, "fat_per_100g": 5.0, "fiber_per_100g": 0.5, "sugar_per_100g": 20.0, "sodium_per_100mg": 50.0, "default_serving_g": 150, "serving_description": "1 katori"},

#     # ── Oils / Fats ──────────────────────────────────────────────────────────
#     {"name": "Sunflower Oil", "brand": None, "category": "Oils/Fats", "calories_per_100g": 884, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Mustard Oil", "brand": None, "category": "Oils/Fats", "calories_per_100g": 884, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Coconut Oil", "brand": None, "category": "Oils/Fats", "calories_per_100g": 892, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 99.1, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Groundnut / Peanut Oil", "brand": None, "category": "Oils/Fats", "calories_per_100g": 884, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Olive Oil (extra virgin)", "brand": None, "category": "Oils/Fats", "calories_per_100g": 884, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 2.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Sesame Oil", "brand": None, "category": "Oils/Fats", "calories_per_100g": 884, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 5, "serving_description": "1 tsp"},
#     {"name": "Rice Bran Oil", "brand": None, "category": "Oils/Fats", "calories_per_100g": 884, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 10, "serving_description": "1 tsp"},
#     {"name": "Butter (unsalted)", "brand": None, "category": "Oils/Fats", "calories_per_100g": 717, "protein_per_100g": 0.9, "carbs_per_100g": 0.1, "fat_per_100g": 81.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.1, "sodium_per_100mg": 11.0, "default_serving_g": 10, "serving_description": "1 tsp"},
#     {"name": "Vanaspati / Dalda", "brand": None, "category": "Oils/Fats", "calories_per_100g": 900, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 100.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 0.0, "default_serving_g": 10, "serving_description": "1 tsp"},

#     # ── Spices / Condiments ──────────────────────────────────────────────────
#     {"name": "Turmeric Powder / Haldi", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 354, "protein_per_100g": 7.8, "carbs_per_100g": 64.9, "fat_per_100g": 9.9, "fiber_per_100g": 21.1, "sugar_per_100g": 3.2, "sodium_per_100mg": 38.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Cumin / Jeera (whole)", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 375, "protein_per_100g": 17.8, "carbs_per_100g": 44.2, "fat_per_100g": 22.3, "fiber_per_100g": 10.5, "sugar_per_100g": 2.3, "sodium_per_100mg": 168.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Coriander Powder / Dhania", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 298, "protein_per_100g": 12.4, "carbs_per_100g": 55.0, "fat_per_100g": 17.8, "fiber_per_100g": 41.9, "sugar_per_100g": 0.0, "sodium_per_100mg": 35.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Red Chilli Powder", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 282, "protein_per_100g": 13.5, "carbs_per_100g": 50.0, "fat_per_100g": 14.3, "fiber_per_100g": 34.5, "sugar_per_100g": 10.3, "sodium_per_100mg": 30.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Garam Masala", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 312, "protein_per_100g": 11.9, "carbs_per_100g": 50.2, "fat_per_100g": 15.1, "fiber_per_100g": 22.8, "sugar_per_100g": 3.1, "sodium_per_100mg": 60.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Ginger Powder / Sonth", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 347, "protein_per_100g": 8.7, "carbs_per_100g": 71.6, "fat_per_100g": 4.2, "fiber_per_100g": 14.1, "sugar_per_100g": 3.4, "sodium_per_100mg": 27.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Mustard Seeds / Rai", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 508, "protein_per_100g": 26.1, "carbs_per_100g": 28.1, "fat_per_100g": 36.2, "fiber_per_100g": 12.2, "sugar_per_100g": 6.8, "sodium_per_100mg": 13.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Fenugreek Seeds / Methi Dana", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 323, "protein_per_100g": 23.0, "carbs_per_100g": 58.4, "fat_per_100g": 6.4, "fiber_per_100g": 24.6, "sugar_per_100g": 0.0, "sodium_per_100mg": 67.0, "default_serving_g": 3, "serving_description": "1/2 tsp"},
#     {"name": "Soy Sauce", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 60, "protein_per_100g": 5.7, "carbs_per_100g": 5.6, "fat_per_100g": 0.1, "fiber_per_100g": 0.8, "sugar_per_100g": 1.7, "sodium_per_100mg": 5720.0, "default_serving_g": 15, "serving_description": "1 tbsp"},
#     {"name": "Tomato Ketchup", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 112, "protein_per_100g": 1.0, "carbs_per_100g": 26.1, "fat_per_100g": 0.4, "fiber_per_100g": 0.3, "sugar_per_100g": 22.0, "sodium_per_100mg": 907.0, "default_serving_g": 17, "serving_description": "1 tbsp"},
#     {"name": "Green Chutney (coriander)", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 68, "protein_per_100g": 2.5, "carbs_per_100g": 10.8, "fat_per_100g": 2.2, "fiber_per_100g": 3.0, "sugar_per_100g": 3.5, "sodium_per_100mg": 200.0, "default_serving_g": 30, "serving_description": "2 tbsp"},
#     {"name": "Tamarind Chutney", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 116, "protein_per_100g": 0.8, "carbs_per_100g": 30.0, "fat_per_100g": 0.1, "fiber_per_100g": 1.5, "sugar_per_100g": 24.0, "sodium_per_100mg": 200.0, "default_serving_g": 20, "serving_description": "1 tbsp"},
#     {"name": "Jaggery / Gur", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 383, "protein_per_100g": 0.4, "carbs_per_100g": 98.0, "fat_per_100g": 0.1, "fiber_per_100g": 0.0, "sugar_per_100g": 95.0, "sodium_per_100mg": 30.0, "default_serving_g": 10, "serving_description": "1 tsp"},
#     {"name": "Sugar (white)", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 400, "protein_per_100g": 0.0, "carbs_per_100g": 100.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 100.0, "sodium_per_100mg": 1.0, "default_serving_g": 10, "serving_description": "1 tsp"},
#     {"name": "Honey", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 304, "protein_per_100g": 0.3, "carbs_per_100g": 82.4, "fat_per_100g": 0.0, "fiber_per_100g": 0.2, "sugar_per_100g": 82.1, "sodium_per_100mg": 4.0, "default_serving_g": 21, "serving_description": "1 tbsp"},
#     {"name": "Salt (table)", "brand": None, "category": "Spices/Condiments", "calories_per_100g": 0, "protein_per_100g": 0.0, "carbs_per_100g": 0.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 38758.0, "default_serving_g": 5, "serving_description": "1 tsp"},

#     # ── Session 5 additions (seed version 2) — 50 new foods ───────────────

#     # Vegetables (10 new)
#     {"name": "Ash Gourd / Petha", "brand": None, "category": "Vegetables", "calories_per_100g": 10, "protein_per_100g": 0.4, "carbs_per_100g": 2.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 2.0, "default_serving_g": 100, "serving_description": "100g chopped"},
#     {"name": "Snake Gourd / Chichinda", "brand": None, "category": "Vegetables", "calories_per_100g": 18, "protein_per_100g": 0.5, "carbs_per_100g": 3.6, "fat_per_100g": 0.3, "fiber_per_100g": 0.6, "sugar_per_100g": 2.0, "sodium_per_100mg": 3.0, "default_serving_g": 100, "serving_description": "100g sliced"},
#     {"name": "Ivy Gourd / Tindora", "brand": None, "category": "Vegetables", "calories_per_100g": 18, "protein_per_100g": 1.2, "carbs_per_100g": 3.1, "fat_per_100g": 0.1, "fiber_per_100g": 1.6, "sugar_per_100g": 1.5, "sodium_per_100mg": 5.0, "default_serving_g": 100, "serving_description": "100g sliced"},
#     {"name": "Pointed Gourd / Parwal", "brand": None, "category": "Vegetables", "calories_per_100g": 20, "protein_per_100g": 2.0, "carbs_per_100g": 2.2, "fat_per_100g": 0.3, "fiber_per_100g": 3.0, "sugar_per_100g": 1.0, "sodium_per_100mg": 4.0, "default_serving_g": 100, "serving_description": "100g sliced"},
#     {"name": "Cluster Beans / Gawar Phali", "brand": None, "category": "Vegetables", "calories_per_100g": 16, "protein_per_100g": 3.2, "carbs_per_100g": 10.8, "fat_per_100g": 0.4, "fiber_per_100g": 3.2, "sugar_per_100g": 0.0, "sodium_per_100mg": 3.0, "default_serving_g": 100, "serving_description": "100g chopped"},
#     {"name": "Yam / Suran", "brand": None, "category": "Vegetables", "calories_per_100g": 118, "protein_per_100g": 1.5, "carbs_per_100g": 27.9, "fat_per_100g": 0.2, "fiber_per_100g": 4.1, "sugar_per_100g": 0.5, "sodium_per_100mg": 9.0, "default_serving_g": 100, "serving_description": "100g cubed"},
#     {"name": "Colocasia / Arbi", "brand": None, "category": "Vegetables", "calories_per_100g": 112, "protein_per_100g": 1.5, "carbs_per_100g": 26.5, "fat_per_100g": 0.2, "fiber_per_100g": 4.1, "sugar_per_100g": 0.4, "sodium_per_100mg": 11.0, "default_serving_g": 100, "serving_description": "100g cubed"},
#     {"name": "Raw Banana / Kachha Kela", "brand": None, "category": "Vegetables", "calories_per_100g": 116, "protein_per_100g": 1.3, "carbs_per_100g": 31.9, "fat_per_100g": 0.4, "fiber_per_100g": 2.3, "sugar_per_100g": 0.5, "sodium_per_100mg": 2.0, "default_serving_g": 100, "serving_description": "100g sliced"},
#     {"name": "Drumstick / Moringa Pods", "brand": None, "category": "Vegetables", "calories_per_100g": 37, "protein_per_100g": 2.1, "carbs_per_100g": 8.5, "fat_per_100g": 0.2, "fiber_per_100g": 3.2, "sugar_per_100g": 0.0, "sodium_per_100mg": 42.0, "default_serving_g": 100, "serving_description": "2-3 sticks"},
#     {"name": "Lotus Stem / Kamal Kakdi", "brand": None, "category": "Vegetables", "calories_per_100g": 74, "protein_per_100g": 2.6, "carbs_per_100g": 16.0, "fat_per_100g": 0.1, "fiber_per_100g": 4.9, "sugar_per_100g": 0.0, "sodium_per_100mg": 40.0, "default_serving_g": 100, "serving_description": "100g sliced"},

#     # Fruits (5 new)
#     {"name": "Jamun / Java Plum", "brand": None, "category": "Fruits", "calories_per_100g": 60, "protein_per_100g": 0.7, "carbs_per_100g": 15.6, "fat_per_100g": 0.2, "fiber_per_100g": 0.6, "sugar_per_100g": 14.0, "sodium_per_100mg": 14.0, "default_serving_g": 100, "serving_description": "10-12 fruits"},
#     {"name": "Wood Apple / Bael", "brand": None, "category": "Fruits", "calories_per_100g": 137, "protein_per_100g": 1.8, "carbs_per_100g": 31.8, "fat_per_100g": 0.3, "fiber_per_100g": 2.9, "sugar_per_100g": 28.0, "sodium_per_100mg": 0.0, "default_serving_g": 100, "serving_description": "pulp from 1 fruit"},
#     {"name": "Star Fruit / Kamrakh", "brand": None, "category": "Fruits", "calories_per_100g": 31, "protein_per_100g": 1.0, "carbs_per_100g": 6.7, "fat_per_100g": 0.3, "fiber_per_100g": 2.8, "sugar_per_100g": 4.0, "sodium_per_100mg": 2.0, "default_serving_g": 100, "serving_description": "1 medium fruit"},
#     {"name": "Indian Gooseberry / Amla", "brand": None, "category": "Fruits", "calories_per_100g": 44, "protein_per_100g": 0.9, "carbs_per_100g": 10.2, "fat_per_100g": 0.6, "fiber_per_100g": 4.3, "sugar_per_100g": 4.0, "sodium_per_100mg": 1.0, "default_serving_g": 50, "serving_description": "2-3 amla"},
#     {"name": "Custard Apple / Sitaphal", "brand": None, "category": "Fruits", "calories_per_100g": 101, "protein_per_100g": 1.6, "carbs_per_100g": 25.2, "fat_per_100g": 0.6, "fiber_per_100g": 2.4, "sugar_per_100g": 20.0, "sodium_per_100mg": 4.0, "default_serving_g": 100, "serving_description": "pulp from 1 fruit"},

#     # Legumes/Pulses (5 new)
#     {"name": "Horse Gram / Kulthi Dal", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 321, "protein_per_100g": 22.0, "carbs_per_100g": 57.2, "fat_per_100g": 0.5, "fiber_per_100g": 5.3, "sugar_per_100g": 1.0, "sodium_per_100mg": 28.0, "default_serving_g": 30, "serving_description": "30g dry"},
#     {"name": "Moth Bean / Matki (sprouted)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 43, "protein_per_100g": 3.0, "carbs_per_100g": 6.5, "fat_per_100g": 0.4, "fiber_per_100g": 1.8, "sugar_per_100g": 1.0, "sodium_per_100mg": 6.0, "default_serving_g": 100, "serving_description": "1 katori sprouts"},
#     {"name": "Rajma / Kidney Beans (canned)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 84, "protein_per_100g": 5.2, "carbs_per_100g": 14.0, "fat_per_100g": 0.3, "fiber_per_100g": 4.3, "sugar_per_100g": 1.0, "sodium_per_100mg": 256.0, "default_serving_g": 130, "serving_description": "1/2 can drained"},
#     {"name": "Green Peas (frozen)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 77, "protein_per_100g": 5.4, "carbs_per_100g": 13.6, "fat_per_100g": 0.4, "fiber_per_100g": 4.5, "sugar_per_100g": 5.5, "sodium_per_100mg": 5.0, "default_serving_g": 80, "serving_description": "1 katori"},
#     {"name": "Val Dal / Field Beans (dry)", "brand": None, "category": "Legumes/Pulses", "calories_per_100g": 340, "protein_per_100g": 24.9, "carbs_per_100g": 60.1, "fat_per_100g": 0.8, "fiber_per_100g": 6.3, "sugar_per_100g": 2.0, "sodium_per_100mg": 12.0, "default_serving_g": 30, "serving_description": "30g dry"},

#     # Dairy (5 new)
#     {"name": "Lassi (sweet)", "brand": None, "category": "Dairy", "calories_per_100g": 70, "protein_per_100g": 2.8, "carbs_per_100g": 11.0, "fat_per_100g": 1.8, "fiber_per_100g": 0.0, "sugar_per_100g": 10.5, "sodium_per_100mg": 45.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Chaas / Buttermilk (plain)", "brand": None, "category": "Dairy", "calories_per_100g": 19, "protein_per_100g": 1.5, "carbs_per_100g": 2.0, "fat_per_100g": 0.7, "fiber_per_100g": 0.0, "sugar_per_100g": 2.0, "sodium_per_100mg": 50.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Shrikhand", "brand": None, "category": "Dairy", "calories_per_100g": 220, "protein_per_100g": 5.0, "carbs_per_100g": 35.0, "fat_per_100g": 7.0, "fiber_per_100g": 0.0, "sugar_per_100g": 32.0, "sodium_per_100mg": 40.0, "default_serving_g": 80, "serving_description": "1 katori"},
#     {"name": "Mishti Doi / Sweet Yogurt", "brand": None, "category": "Dairy", "calories_per_100g": 115, "protein_per_100g": 3.5, "carbs_per_100g": 18.0, "fat_per_100g": 3.5, "fiber_per_100g": 0.0, "sugar_per_100g": 17.0, "sodium_per_100mg": 40.0, "default_serving_g": 100, "serving_description": "1 small cup"},
#     {"name": "Mawa / Khoya", "brand": None, "category": "Dairy", "calories_per_100g": 321, "protein_per_100g": 14.6, "carbs_per_100g": 20.5, "fat_per_100g": 21.0, "fiber_per_100g": 0.0, "sugar_per_100g": 18.0, "sodium_per_100mg": 120.0, "default_serving_g": 30, "serving_description": "30g piece"},

#     # Fish/Seafood (5 new)
#     {"name": "Bangda / Indian Mackerel", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 139, "protein_per_100g": 19.0, "carbs_per_100g": 0.0, "fat_per_100g": 6.3, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 90.0, "default_serving_g": 100, "serving_description": "1 fillet"},
#     {"name": "Surmai / Seer Fish", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 109, "protein_per_100g": 22.0, "carbs_per_100g": 0.0, "fat_per_100g": 2.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 60.0, "default_serving_g": 100, "serving_description": "1 fillet"},
#     {"name": "Catla / Katla Fish", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 97, "protein_per_100g": 17.0, "carbs_per_100g": 0.0, "fat_per_100g": 2.8, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 50.0, "default_serving_g": 100, "serving_description": "1 piece"},
#     {"name": "Bombay Duck / Bombil (dried)", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 300, "protein_per_100g": 61.0, "carbs_per_100g": 0.0, "fat_per_100g": 5.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 800.0, "default_serving_g": 30, "serving_description": "2-3 pieces"},
#     {"name": "Squid / Calamari", "brand": None, "category": "Fish/Seafood", "calories_per_100g": 92, "protein_per_100g": 15.6, "carbs_per_100g": 3.1, "fat_per_100g": 1.4, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 44.0, "default_serving_g": 100, "serving_description": "100g cooked"},

#     # Meat/Poultry (5 new)
#     {"name": "Mutton Liver", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 165, "protein_per_100g": 26.0, "carbs_per_100g": 3.8, "fat_per_100g": 5.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 87.0, "default_serving_g": 100, "serving_description": "100g cooked"},
#     {"name": "Chicken Drumstick (skinless)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 161, "protein_per_100g": 28.0, "carbs_per_100g": 0.0, "fat_per_100g": 5.2, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 90.0, "default_serving_g": 120, "serving_description": "1 drumstick"},
#     {"name": "Pork Belly", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 518, "protein_per_100g": 9.3, "carbs_per_100g": 0.0, "fat_per_100g": 53.0, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 32.0, "default_serving_g": 85, "serving_description": "85g slice"},
#     {"name": "Duck Meat (roasted)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 201, "protein_per_100g": 23.5, "carbs_per_100g": 0.0, "fat_per_100g": 11.2, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 65.0, "default_serving_g": 100, "serving_description": "100g meat"},
#     {"name": "Quail / Bater (cooked)", "brand": None, "category": "Meat/Poultry", "calories_per_100g": 192, "protein_per_100g": 25.0, "carbs_per_100g": 0.0, "fat_per_100g": 9.6, "fiber_per_100g": 0.0, "sugar_per_100g": 0.0, "sodium_per_100mg": 52.0, "default_serving_g": 100, "serving_description": "1 quail"},

#     # Beverages (5 new)
#     {"name": "Nimbu Pani / Lemonade (Indian)", "brand": None, "category": "Beverages", "calories_per_100g": 25, "protein_per_100g": 0.1, "carbs_per_100g": 6.5, "fat_per_100g": 0.0, "fiber_per_100g": 0.1, "sugar_per_100g": 5.5, "sodium_per_100mg": 100.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Jal Jeera", "brand": None, "category": "Beverages", "calories_per_100g": 15, "protein_per_100g": 0.2, "carbs_per_100g": 3.5, "fat_per_100g": 0.1, "fiber_per_100g": 0.3, "sugar_per_100g": 2.0, "sodium_per_100mg": 120.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Thandai", "brand": None, "category": "Beverages", "calories_per_100g": 98, "protein_per_100g": 3.0, "carbs_per_100g": 12.0, "fat_per_100g": 4.5, "fiber_per_100g": 0.5, "sugar_per_100g": 10.0, "sodium_per_100mg": 30.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Kokum Sharbat", "brand": None, "category": "Beverages", "calories_per_100g": 28, "protein_per_100g": 0.1, "carbs_per_100g": 7.0, "fat_per_100g": 0.0, "fiber_per_100g": 0.2, "sugar_per_100g": 6.0, "sodium_per_100mg": 15.0, "default_serving_g": 250, "serving_description": "1 glass"},
#     {"name": "Sattu Drink", "brand": None, "category": "Beverages", "calories_per_100g": 35, "protein_per_100g": 2.5, "carbs_per_100g": 6.0, "fat_per_100g": 0.5, "fiber_per_100g": 1.0, "sugar_per_100g": 3.0, "sodium_per_100mg": 80.0, "default_serving_g": 250, "serving_description": "1 glass"},

#     # Snacks (5 new — gluten-free Indian snacks)
#     {"name": "Makhana / Fox Nuts (roasted)", "brand": None, "category": "Snacks", "calories_per_100g": 332, "protein_per_100g": 9.7, "carbs_per_100g": 76.9, "fat_per_100g": 0.1, "fiber_per_100g": 14.5, "sugar_per_100g": 0.0, "sodium_per_100mg": 210.0, "default_serving_g": 30, "serving_description": "1 katori"},
#     {"name": "Kurmura Chivda (rice flakes)", "brand": None, "category": "Snacks", "calories_per_100g": 410, "protein_per_100g": 6.0, "carbs_per_100g": 65.0, "fat_per_100g": 14.0, "fiber_per_100g": 2.0, "sugar_per_100g": 3.0, "sodium_per_100mg": 350.0, "default_serving_g": 30, "serving_description": "1 katori"},
#     {"name": "Sabudana Vada", "brand": None, "category": "Snacks", "calories_per_100g": 300, "protein_per_100g": 4.5, "carbs_per_100g": 42.0, "fat_per_100g": 13.0, "fiber_per_100g": 1.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 250.0, "default_serving_g": 40, "serving_description": "1 vada"},
#     {"name": "Rice Murukku / Chakli (rice)", "brand": None, "category": "Snacks", "calories_per_100g": 445, "protein_per_100g": 5.5, "carbs_per_100g": 60.0, "fat_per_100g": 20.0, "fiber_per_100g": 1.5, "sugar_per_100g": 1.0, "sodium_per_100mg": 300.0, "default_serving_g": 25, "serving_description": "2-3 pieces"},
#     {"name": "Roasted Chana / Bhuna Chana", "brand": None, "category": "Snacks", "calories_per_100g": 369, "protein_per_100g": 22.5, "carbs_per_100g": 58.1, "fat_per_100g": 5.2, "fiber_per_100g": 15.0, "sugar_per_100g": 5.0, "sodium_per_100mg": 24.0, "default_serving_g": 30, "serving_description": "1 katori"},

#     # Sweets/Desserts (5 new)
#     {"name": "Kalakand", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 310, "protein_per_100g": 8.5, "carbs_per_100g": 40.0, "fat_per_100g": 13.5, "fiber_per_100g": 0.0, "sugar_per_100g": 36.0, "sodium_per_100mg": 45.0, "default_serving_g": 30, "serving_description": "1 piece"},
#     {"name": "Sandesh", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 260, "protein_per_100g": 10.0, "carbs_per_100g": 35.0, "fat_per_100g": 10.0, "fiber_per_100g": 0.0, "sugar_per_100g": 32.0, "sodium_per_100mg": 45.0, "default_serving_g": 40, "serving_description": "1 piece"},
#     {"name": "Coconut Barfi", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 395, "protein_per_100g": 4.5, "carbs_per_100g": 50.0, "fat_per_100g": 20.0, "fiber_per_100g": 3.0, "sugar_per_100g": 45.0, "sodium_per_100mg": 30.0, "default_serving_g": 30, "serving_description": "1 piece"},
#     {"name": "Phirni", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 130, "protein_per_100g": 3.5, "carbs_per_100g": 20.0, "fat_per_100g": 4.0, "fiber_per_100g": 0.2, "sugar_per_100g": 16.0, "sodium_per_100mg": 35.0, "default_serving_g": 120, "serving_description": "1 katori"},
#     {"name": "Til Ladoo / Sesame Ladoo", "brand": None, "category": "Sweets/Desserts", "calories_per_100g": 460, "protein_per_100g": 12.0, "carbs_per_100g": 45.0, "fat_per_100g": 28.0, "fiber_per_100g": 5.0, "sugar_per_100g": 38.0, "sodium_per_100mg": 15.0, "default_serving_g": 25, "serving_description": "1 ladoo"},
# ]


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _slugify(s: str) -> str:
    """Lowercase, replace non-alphanumeric runs with _, strip edge underscores.
    Must match _slugify in lib/core/utils/seed_key.dart EXACTLY."""
    out = s.strip().lower()
    out = re.sub(r'[^a-z0-9]+', '_', out)
    out = re.sub(r'^_+|_+$', '', out)
    return out


def _make_seed_key(name: str, brand: str | None) -> str:
    """Deterministic key: '{name_slug}__{brand_slug}'.
    Must match makeSeedKey in lib/core/utils/seed_key.dart EXACTLY."""
    name_slug = _slugify(name)
    brand_slug = _slugify(brand) if brand and brand.strip() else 'generic'
    return f"{name_slug}__{brand_slug}"


def _extract_ddl(schema_text: str, table_name: str) -> list[str]:
    """Extract CREATE TABLE and CREATE INDEX statements for a given table."""
    statements = []
    # Split on semicolons and collect matching statements
    for stmt in schema_text.split(";"):
        stmt = stmt.strip()
        if not stmt:
            continue
        upper = stmt.upper()
        if (f"CREATE TABLE {table_name.upper()}" in upper or
                f"CREATE INDEX" in upper and f" ON {table_name.upper()}" in upper):
            statements.append(stmt + ";")
    return statements


def validate(food: dict) -> None:
    assert food["calories_per_100g"] >= 0, f"Negative calories: {food['name']}"
    macro_sum = food["protein_per_100g"] + food["carbs_per_100g"] + food["fat_per_100g"]
    assert macro_sum <= 115, f"Macros sum too high ({macro_sum:.1f}) for: {food['name']}"
    assert food["category"] in VALID_CATEGORIES, f"Bad category: {food['category']} for {food['name']}"
    assert food["gluten_status"] in ("gluten_free", "contains_gluten", "may_contain", "unknown"), \
        f"Bad gluten_status: {food['gluten_status']} for {food['name']}"


def main() -> None:
    # 1. Read schema
    print(f"Reading schema from {SCHEMA_SQL}...")
    schema_text = SCHEMA_SQL.read_text(encoding="utf-8")
    ddl_statements = _extract_ddl(schema_text, "foods")
    if not ddl_statements:
        print("ERROR: Could not find foods table DDL in schema.sql", file=sys.stderr)
        sys.exit(1)

    # 2. Tag gluten
    print(f"Tagging gluten status for {len(FOODS)} foods...")
    tag_all(FOODS)

    # 3. Validate
    for food in FOODS:
        validate(food)

    # 4. Write DB
    print(f"Writing to {OUTPUT}...")
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    if OUTPUT.exists():
        OUTPUT.unlink()

    conn = sqlite3.connect(OUTPUT)
    cur = conn.cursor()

    # Execute schema DDL
    for stmt in ddl_statements:
        cur.execute(stmt)

    # Compute seed_key for each food (must match makeSeedKey in seed_key.dart)
    for food in FOODS:
        food["seed_key"] = _make_seed_key(food["name"], food.get("brand"))

    # Check for duplicate seed_keys — would cause reconciliation bugs
    seen_keys: dict[str, str] = {}
    for food in FOODS:
        key = food["seed_key"]
        if key in seen_keys:
            print(f"ERROR: Duplicate seed_key '{key}'", file=sys.stderr)
            print(f"  First:    {seen_keys[key]}", file=sys.stderr)
            print(f"  Conflict: {food['name']}", file=sys.stderr)
            sys.exit(1)
        seen_keys[key] = food["name"]
    print(f"  {len(seen_keys)} unique seed_keys — no duplicates.")

    # Insert all foods
    insert_sql = """
        INSERT INTO foods (
            name, brand, category,
            calories_per_100g, protein_per_100g, carbs_per_100g, fat_per_100g,
            fiber_per_100g, sugar_per_100g, sodium_per_100mg,
            default_serving_g, serving_description,
            is_gluten_free, gluten_status, is_custom, seed_key
        ) VALUES (
            :name, :brand, :category,
            :calories_per_100g, :protein_per_100g, :carbs_per_100g, :fat_per_100g,
            :fiber_per_100g, :sugar_per_100g, :sodium_per_100mg,
            :default_serving_g, :serving_description,
            :is_gluten_free, :gluten_status, 0, :seed_key
        )
    """
    cur.executemany(insert_sql, FOODS)
    conn.commit()

    # 5. Summary
    total = cur.execute("SELECT COUNT(*) FROM foods").fetchone()[0]
    print(f"\nInserted {total} foods.\n")

    print("By category:")
    for row in cur.execute("SELECT category, COUNT(*) FROM foods GROUP BY category ORDER BY category"):
        print(f"  {row[0]:<30} {row[1]} records")

    print("\nGluten distribution:")
    for row in cur.execute("SELECT gluten_status, COUNT(*) FROM foods GROUP BY gluten_status ORDER BY COUNT(*) DESC"):
        print(f"  {row[0]:<20} {row[1]}")

    conn.close()
    size_kb = OUTPUT.stat().st_size / 1024
    print(f"\nDone. Written to: {OUTPUT}")
    print(f"File size: {size_kb:.1f} KB")


if __name__ == "__main__":
    main()
