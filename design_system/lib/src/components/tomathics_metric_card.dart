import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';
import '../tokens/tomathics_typography.dart';

enum TomathicsMetricTrend { neutral, positive, negative }

/// Compact KPI card for active jobs, success rate, and runtime summaries.
class TomathicsMetricCard extends StatelessWidget {
  const TomathicsMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.detail,
    this.trend = TomathicsMetricTrend.neutral,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? detail;
  final TomathicsMetricTrend trend;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final trendColor = switch (trend) {
      TomathicsMetricTrend.neutral => palette.onSurfaceVariant,
      TomathicsMetricTrend.positive => semantic.success,
      TomathicsMetricTrend.negative => semantic.danger,
    };
    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(TomathicsSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: TomathicsRadius.lgAll,
        border: Border.all(color: palette.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: palette.primary),
              const SizedBox(width: TomathicsSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TomathicsSpacing.md),
          Text(
            value,
            style: TomathicsTypography.headlineMedium.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: TomathicsSpacing.xs),
            Text(
              detail!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: trendColor),
            ),
          ],
        ],
      ),
    );
  }
}
