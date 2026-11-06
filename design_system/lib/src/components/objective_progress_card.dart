import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';
import '../tokens/tomathics_typography.dart';
import 'tomathics_panel.dart';
import 'tomathics_status_badge.dart';

/// Goal summary that pairs completion with the current plan state.
class ObjectiveProgressCard extends StatelessWidget {
  const ObjectiveProgressCard({
    required this.title,
    required this.completed,
    required this.total,
    required this.status,
    this.estimate,
    this.lastRead,
    super.key,
  }) : assert(total > 0),
       assert(completed >= 0);

  final String title;
  final int completed;
  final int total;
  final TomathicsStatus status;
  final String? estimate;
  final String? lastRead;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final palette = Theme.of(context).colorScheme;
    final progress = (completed / total).clamp(0.0, 1.0);
    return TomathicsPanel(
      title: title,
      action: TomathicsStatusBadge(status: status),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: TomathicsSpacing.sm,
            runSpacing: TomathicsSpacing.xs,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$completed',
                    style: TomathicsTypography.headlineMedium.copyWith(
                      color: palette.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text(
                    ' / $total concluídos',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (estimate case final timeEstimate?)
                Text(
                  timeEstimate,
                  style: TomathicsTypography.labelMedium.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: TomathicsSpacing.md),
          ClipRRect(
            borderRadius: TomathicsRadius.pillAll,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: status == TomathicsStatus.failed
                  ? semantic.danger
                  : palette.primary,
            ),
          ),
          if (lastRead != null) ...[
            const SizedBox(height: TomathicsSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 15,
                  color: palette.onSurfaceVariant,
                ),
                const SizedBox(width: TomathicsSpacing.xs),
                Expanded(
                  child: Text(
                    lastRead!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TomathicsTypography.bodySmall.copyWith(
                      color: palette.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
