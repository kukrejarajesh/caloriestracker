import 'package:flutter/material.dart';
import '../core/utils/gluten_utils.dart';

class GlutenBadge extends StatelessWidget {
  final String glutenStatus;
  final bool compact;

  const GlutenBadge({
    super.key,
    required this.glutenStatus,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = GlutenStatus.fromString(glutenStatus);
    final color = GlutenUtils.badgeColor(status, context);
    final icon = GlutenUtils.badgeIcon(status);
    final label = GlutenUtils.label(status);

    if (compact) {
      return Tooltip(
        message: label,
        child: Icon(icon, color: color, size: 18),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
