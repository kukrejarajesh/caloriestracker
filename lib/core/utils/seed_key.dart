/// Computes a stable, deterministic identifier for a seeded food.
///
/// Must match EXACTLY the algorithm used by `tools/seed_foods_db.py` when it
/// emits the seed_key column into `assets/foods.db`. Any divergence causes
/// reconciliation (the "more food available" flow) to duplicate rows instead
/// of skipping existing ones.
///
/// Format: `"{name_slug}__{brand_slug}"` where `brand_slug = 'generic'` when
/// brand is null or empty.
///
/// Examples:
///   makeSeedKey('Dosa', null)           → "dosa__generic"
///   makeSeedKey('Ragi Roti', 'MTR')     → "ragi_roti__mtr"
///   makeSeedKey('  Moong Dal  ', '')    → "moong_dal__generic"
///
/// Rules (do NOT change after v1 is shipped):
///   * lowercase, trim
///   * replace runs of non-[a-z0-9] with a single underscore
///   * strip leading/trailing underscores
///   * join name + brand with double underscore
///
/// Once shipped, the seed_key for any given food row is frozen forever.
/// Breaking this = duplicate rows for existing users on upgrade.
String makeSeedKey(String name, String? brand) {
  final nameSlug = _slugify(name);
  final brandSlug = (brand != null && brand.trim().isNotEmpty)
      ? _slugify(brand)
      : 'generic';
  return '${nameSlug}__$brandSlug';
}

String _slugify(String s) {
  var out = s.toLowerCase().trim();
  out = out.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  out = out.replaceAll(RegExp(r'^_+|_+$'), '');
  return out;
}
