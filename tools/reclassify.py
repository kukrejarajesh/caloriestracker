
import os

mapping = {
    # Spices/Condiments
    'Indian Condiments': 'Spices/Condiments',
    'Asian Sauces': 'Spices/Condiments',
    'Tomato-Based Condiments': 'Spices/Condiments',
    'Dips & Spreads': 'Spices/Condiments',
    'Miscellaneous': 'Spices/Condiments',
    
    # Snacks
    'Chaat': 'Snacks',
    'Dosa & Variants': 'Snacks',
    'Idli & Variants': 'Snacks',
    'Non-Veg Street Food': 'Snacks',
    'Snacks & Street Food': 'Snacks',
    'Fried Snacks': 'Snacks',
    'Wraps & Rolls': 'Snacks',
    'Rolls & Buns': 'Snacks',
    'Sandwiches & Burgers': 'Snacks',
    'Bread Items': 'Snacks',
    'Breads': 'Snacks',
    'Pastries': 'Snacks',
    'Muffins': 'Snacks',
    'Scones & Quick Breads': 'Snacks',
    'Laminated Doughs': 'Snacks',
    'Pizza Hut': 'Snacks',
    'Dominos': 'Snacks',
    'KFC': 'Snacks',
    "McDonald's": 'Snacks',
    'Other Fast Food': 'Snacks',
    'Mainland China': 'Snacks',
    'Breakfast': 'Snacks',
    'Specialty & Artisanal': 'Snacks',
    'Packaged & Branded Foods': 'Snacks',
    
    # Sweets/Desserts
    'Sweets & Desserts': 'Sweets/Desserts',
    'Desserts & Sweets': 'Sweets/Desserts',
    'Cakes': 'Sweets/Desserts',
    'Cookies': 'Sweets/Desserts',
    'Brownies & Bars': 'Sweets/Desserts',
    'Donuts': 'Sweets/Desserts',
    'Tarts & Pies': 'Sweets/Desserts',
    
    # Legumes/Pulses
    'Curries & Dals': 'Legumes/Pulses',
    
    # Grains/Cereals
    'Rice & Roti': 'Grains/Cereals',
    'Noodles & Rice': 'Grains/Cereals',
    
    # Dairy
    'Dairy & Proteins': 'Dairy',
    
    # Beverages
    'Chai Point': 'Beverages'
}

filepath = 'tools/merged_foods_final.py'
if os.path.exists(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    for old_cat, new_cat in mapping.items():
        # Using regex-like replacement to ensure we only hit category values
        # This handles both 'category': 'Old' and "category": "Old"
        content = content.replace(f"'category': '{old_cat}'", f"'category': '{new_cat}'")
        content = content.replace(f'"category": "{old_cat}"', f'"category": "{new_cat}"')
        content = content.replace(f"'category': \"{old_cat}\"", f"'category': '{new_cat}'")
        content = content.replace(f"\"category\": '{old_cat}'", f"\"category\": \"{new_cat}\"")

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Successfully reclassified merged_foods_final.py')
else:
    print(f'Error: {filepath} not found')
