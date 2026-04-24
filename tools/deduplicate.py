
import os
import re

def slugify(s):
    out = s.strip().lower()
    out = re.sub(r'[^a-z0-9]+', '_', out)
    out = re.sub(r'^_+|_+$', '', out)
    return out

def make_seed_key(name, brand):
    name_slug = slugify(name)
    brand_slug = slugify(brand) if brand and brand.strip() else 'generic'
    return f"{name_slug}__{brand_slug}"

filepath = 'tools/merged_foods_final.py'
if os.path.exists(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    seen_keys = set()
    duplicates_removed = 0

    # Pattern to extract name and brand from a line like:
    # {'name': '...', 'brand': None, ...}
    name_pattern = re.compile(r"'name':\s*['\"](.*?)['\"]")
    brand_pattern = re.compile(r"'brand':\s*(['\"].*?['\"]|None)")

    for line in lines:
        if line.strip().startswith('{'):
            name_match = name_pattern.search(line)
            brand_match = brand_pattern.search(line)
            
            if name_match:
                name = name_match.group(1)
                brand_str = brand_match.group(1) if brand_match else 'None'
                brand = None if brand_str == 'None' else brand_str.strip("'\"")
                
                key = make_seed_key(name, brand)
                if key in seen_keys:
                    print(f"Removing duplicate: {name} ({brand}) -> {key}")
                    duplicates_removed += 1
                    continue
                seen_keys.add(key)
        
        new_lines.append(line)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    
    print(f'Successfully processed merged_foods_final.py. Removed {duplicates_removed} duplicates.')
else:
    print(f'Error: {filepath} not found')
