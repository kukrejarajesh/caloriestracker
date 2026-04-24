
filepath = 'tools/merged_foods_final.py'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Handle both single and double quotes
content = content.replace("'sodium_per_100g'", "'sodium_per_100mg'")
content = content.replace('"sodium_per_100g"', '"sodium_per_100mg"')

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
print('Successfully renamed sodium_per_100g to sodium_per_100mg')
