"""
tag_gluten.py — Rule-based gluten status tagger.

This is a pure module (no I/O, no side effects).
Import and call tag_gluten() or tag_all() from seed scripts.

Gluten status values:
  gluten_free     — confirmed safe
  contains_gluten — definitively contains gluten
  may_contain     — cross-contamination risk
  unknown         — fallback (should not appear in seeded data)
"""

# ---------------------------------------------------------------------------
# Override dict — for names where substring rules give the wrong answer
# ---------------------------------------------------------------------------
OVERRIDES: dict[str, str] = {
    "rice noodles": "gluten_free",
    "rice vermicelli": "gluten_free",
    "rice flakes": "gluten_free",
    "buckwheat": "gluten_free",       # "wheat" substring would mis-tag this
    "buckwheat flour": "gluten_free",
    "tamari": "gluten_free",          # wheat-free soy sauce
    "poha": "gluten_free",            # flattened rice, not wheat
    "murmura": "gluten_free",         # puffed rice
    "puffed rice": "gluten_free",
    "sabudana": "gluten_free",        # tapioca pearls
    "idli": "gluten_free",
    "dosa": "gluten_free",
    "appam": "gluten_free",
    "uttapam": "gluten_free",
    "rasam": "gluten_free",
    "sambhar": "gluten_free",
    "sambar": "gluten_free",
}

# ---------------------------------------------------------------------------
# Tier 1 — contains_gluten keyword fragments (case-insensitive)
# ---------------------------------------------------------------------------
CONTAINS_GLUTEN_KEYWORDS: list[str] = [
    # Wheat flours and raw grains
    "maida", "atta", "whole wheat", "wheat flour",
    "semolina", "sooji", "suji", "rava", "rawa",
    "barley", "rye", "spelt", "farro", "bulgur", "couscous",
    "kamut", "einkorn", "triticale",
    "seitan", "vital wheat gluten",
    "dalia", "lapsi", "broken wheat",
    "nuggets", "fish fingers", "fish finger",

    # Breads and flatbreads
    "bread", "roti", "chapati", "chapatti", "phulka",
    "naan", "paratha", "parotta", "puri", "poori",
    "bhatura", "kulcha", "lachha",
    "toast", "loaf",

    # Pasta and noodles (wheat-based)
    "pasta", "spaghetti", "penne", "macaroni", "linguine",
    "fettuccine", "tagliatelle", "rigatoni", "fusilli",
    "lasagna", "lasagne", "ravioli", "gnocchi",
    "noodles", "udon", "ramen", "soba",
    "vermicelli",          # wheat vermicelli (rice vermicelli overridden above)

    # Baked goods and pastry
    "biscuit", "cookie", "cracker", "digestive",
    "cake", "pastry", "pie crust", "tart shell", "wafer",
    "muffin", "scone", "croissant", "bagel", "pretzel",
    "doughnut", "donut", "pancake", "waffle",

    # Indian wheat-based snacks and sweets
    "upma",                # sooji-based
    "samosa",              # wheat wrapper
    "kachori",             # maida wrapper
    "jalebi",              # maida batter
    "gulab jamun",         # khoya + maida
    "imarti",
    "halwa",               # sooji/semolina halwa
    "sheera",              # sooji sheera
    "besan ladoo",         # note: plain besan is GF but "besan ladoo" fine below
    "motichoor",
    "mathri",
    "namak pare",
    "chakli wheat",
    "sev",                 # besan sev — override below if needed
    "bhujia wheat",
    "papdi",               # maida papdi
    "gujiya",              # maida wrapper
    "baati",               # wheat litti baati
    "litti",

    # Other
    "malt", "malt vinegar",
    "beer", "lager", "ale", "stout",
    "worcestershire",
    "tempeh",              # soy but often wheat-fermented
]

# ---------------------------------------------------------------------------
# Tier 2 — may_contain keyword fragments (cross-contamination risk)
# ---------------------------------------------------------------------------
MAY_CONTAIN_KEYWORDS: list[str] = [
    "oats", "oatmeal", "rolled oats", "oat flour",
    "chips", "crisps",
    "popcorn seasoned", "flavored popcorn",
    "chocolate", "cocoa powder",
    "ice cream",
    "energy bar", "protein bar", "cereal bar", "granola bar",
    "muesli", "granola", "corn flakes",
    "processed cheese", "cheese spread", "cheese slice",
    "soy sauce",
    "tomato ketchup", "ketchup",
    "garam masala",
    "seasoning mix", "spice mix", "masala mix", "masala powder",
    "stock cube", "bouillon",
    "namkeen", "mixture",
    "instant soup",
    "mayonnaise",
    "salad dressing",
    "protein shake", "protein powder",
    "energy drink",
    "flavored yogurt", "flavoured yogurt",
    "miso",
]

# ---------------------------------------------------------------------------
# Besan (chickpea flour) override — besan itself is GF
# ---------------------------------------------------------------------------
BESAN_SAFE: list[str] = [
    "besan", "chickpea flour", "gram flour",
    "chilla", "pakoda", "pakora", "bhajia",
    "dhokla", "khandvi", "missi roti",
]


def _normalise(text: str) -> str:
    return text.strip().lower()


def tag_gluten(name: str, category: str) -> tuple[str, int]:
    """
    Returns (gluten_status, is_gluten_free) for a food item.

    Args:
        name:     Food name (e.g. "Basmati Rice", "Whole Wheat Bread")
        category: Food category (e.g. "Grains/Cereals", "Dairy")

    Returns:
        Tuple of (gluten_status_str, is_gluten_free_int)
        where gluten_status_str ∈ {'gluten_free','contains_gluten','may_contain','unknown'}
        and   is_gluten_free_int ∈ {0, 1}
    """
    n = _normalise(name)

    # 1. Check override dict first (exact substring match against override keys)
    for key, status in OVERRIDES.items():
        if key in n:
            gf = 1 if status == "gluten_free" else 0
            return status, gf

    # 2. Besan safe-list — chickpea flour is inherently gluten-free
    for key in BESAN_SAFE:
        if key in n:
            return "gluten_free", 1

    # 3. Tier 1 — contains_gluten
    for kw in CONTAINS_GLUTEN_KEYWORDS:
        if kw in n:
            return "contains_gluten", 0

    # 4. Tier 2 — may_contain
    for kw in MAY_CONTAIN_KEYWORDS:
        if kw in n:
            return "may_contain", 0

    # 5. Default — gluten_free
    return "gluten_free", 1


def tag_all(foods: list[dict]) -> list[dict]:
    """
    Mutates each food dict in-place, adding 'gluten_status' and 'is_gluten_free'.
    Returns the same list (for chaining).
    """
    for food in foods:
        status, gf_flag = tag_gluten(food["name"], food.get("category", ""))
        food["gluten_status"] = status
        food["is_gluten_free"] = gf_flag
    return foods


# ---------------------------------------------------------------------------
# Self-test — run: python tag_gluten.py
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    test_cases = [
        # (name, category, expected_status)
        ("Basmati Rice", "Grains/Cereals", "gluten_free"),
        ("Whole Wheat Bread", "Grains/Cereals", "contains_gluten"),
        ("Roti", "Grains/Cereals", "contains_gluten"),
        ("Naan", "Grains/Cereals", "contains_gluten"),
        ("Upma", "Grains/Cereals", "contains_gluten"),
        ("Idli", "Grains/Cereals", "gluten_free"),
        ("Dosa", "Grains/Cereals", "gluten_free"),
        ("Poha", "Grains/Cereals", "gluten_free"),
        ("Buckwheat", "Grains/Cereals", "gluten_free"),
        ("Oats", "Grains/Cereals", "may_contain"),
        ("Spaghetti", "Grains/Cereals", "contains_gluten"),
        ("Rice Noodles", "Grains/Cereals", "gluten_free"),
        ("Samosa", "Snacks", "contains_gluten"),
        ("Jalebi", "Sweets/Desserts", "contains_gluten"),
        ("Rasgulla", "Sweets/Desserts", "gluten_free"),
        ("Chicken Breast", "Meat/Poultry", "gluten_free"),
        ("Chicken Nuggets", "Meat/Poultry", "contains_gluten"),
        ("Salmon", "Fish/Seafood", "gluten_free"),
        ("Full Fat Milk", "Dairy", "gluten_free"),
        ("Processed Cheese", "Dairy", "may_contain"),
        ("Toor Dal", "Legumes/Pulses", "gluten_free"),
        ("Potato Chips", "Snacks", "may_contain"),
        ("Dark Chocolate", "Snacks", "may_contain"),
        ("Besan Chilla", "Snacks", "gluten_free"),
        ("Turmeric Powder", "Spices/Condiments", "gluten_free"),
        ("Soy Sauce", "Spices/Condiments", "may_contain"),
        ("Tamari", "Spices/Condiments", "gluten_free"),
        ("Beer", "Beverages", "contains_gluten"),
        ("Coconut Water", "Beverages", "gluten_free"),
        ("Halwa", "Sweets/Desserts", "contains_gluten"),
        ("Gajar Halwa", "Sweets/Desserts", "contains_gluten"),  # contains "halwa"
        ("Sabudana", "Grains/Cereals", "gluten_free"),
        ("Murmura", "Snacks", "gluten_free"),
    ]

    print(f"{'Name':<30} {'Expected':<20} {'Got':<20} {'Pass?'}")
    print("-" * 80)
    passes = 0
    for name, cat, expected in test_cases:
        status, gf = tag_gluten(name, cat)
        ok = "PASS" if status == expected else "FAIL"
        if ok == "PASS":
            passes += 1
        print(f"{name:<30} {expected:<20} {status:<20} {ok}")

    print(f"\n{passes}/{len(test_cases)} tests passed.")
