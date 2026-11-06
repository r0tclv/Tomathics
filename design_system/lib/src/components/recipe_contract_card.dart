import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_spacing.dart';
import '../tokens/tomathics_typography.dart';
import 'tomathics_panel.dart';

/// Compact recipe contract: what the automation consumes and produces.
class RecipeContractCard extends StatelessWidget {
  const RecipeContractCard({
    required this.title,
    required this.consumes,
    required this.produces,
    this.location,
    super.key,
  });

  final String title;
  final List<String> consumes;
  final List<String> produces;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    return TomathicsPanel(
      title: title,
      subtitle: location,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ContractColumn(
              label: 'CONSOME',
              icon: Icons.south_east_rounded,
              color: semantic.warning,
              values: consumes,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Icon(Icons.arrow_forward_rounded, size: 18),
          ),
          Expanded(
            child: _ContractColumn(
              label: 'PRODUZ',
              icon: Icons.north_east_rounded,
              color: semantic.success,
              values: produces,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractColumn extends StatelessWidget {
  const _ContractColumn({
    required this.label,
    required this.icon,
    required this.color,
    required this.values,
  });

  final String label;
  final IconData icon;
  final Color color;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TomathicsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: TomathicsSpacing.xs),
              Text(
                label,
                style: TomathicsTypography.labelSmall.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: TomathicsSpacing.sm),
          for (final value in values)
            Padding(
              padding: const EdgeInsets.only(bottom: TomathicsSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 6, right: 7),
                    decoration: BoxDecoration(
                      color: palette.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(value, style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
