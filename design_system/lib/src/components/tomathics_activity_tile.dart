import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';
import 'tomathics_status_badge.dart';

/// Reusable monitor or history row for a run event or target update.
class TomathicsActivityTile extends StatelessWidget {
  const TomathicsActivityTile({
    required this.title,
    required this.detail,
    required this.time,
    this.icon,
    this.status,
    super.key,
  });

  final String title;
  final String detail;
  final String time;
  final IconData? icon;
  final TomathicsStatus? status;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final accent = switch (status) {
      TomathicsStatus.completed => semantic.success,
      TomathicsStatus.failed || TomathicsStatus.blocked => semantic.danger,
      TomathicsStatus.attention ||
      TomathicsStatus.waiting ||
      TomathicsStatus.stale => semantic.warning,
      TomathicsStatus.running => semantic.info,
      _ => palette.primary,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TomathicsSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: TomathicsRadius.smAll,
            ),
            child: Icon(
              icon ?? Icons.bolt_rounded,
              size: 18,
              color: accent,
            ),
          ),
          const SizedBox(width: TomathicsSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: TomathicsSpacing.xxs),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TomathicsSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: palette.onSurfaceVariant,
                  letterSpacing: 0,
                ),
              ),
              if (status != null) ...[
                const SizedBox(height: TomathicsSpacing.xs),
                TomathicsStatusBadge(status: status!, compact: true),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
