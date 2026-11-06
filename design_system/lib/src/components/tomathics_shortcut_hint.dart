import 'package:flutter/material.dart';

import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';
import '../tokens/tomathics_typography.dart';

/// Keyboard shortcut treatment for desktop editor menus and tooltips.
class TomathicsShortcutHint extends StatelessWidget {
  const TomathicsShortcutHint({required this.keys, this.label, super.key});

  final List<String> keys;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label case final shortcutLabel?) ...[
          Text(
            shortcutLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.onSurfaceVariant),
          ),
          const SizedBox(width: TomathicsSpacing.sm),
        ],
        for (var index = 0; index < keys.length; index++) ...[
          if (index > 0)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TomathicsSpacing.xxs,
              ),
              child: Text(
                '+',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: palette.onSurfaceVariant,
                ),
              ),
            ),
          Container(
            constraints: const BoxConstraints(minWidth: 26, minHeight: 24),
            padding: const EdgeInsets.symmetric(
              horizontal: TomathicsSpacing.xs,
              vertical: TomathicsSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: palette.surfaceContainerHighest,
              borderRadius: TomathicsRadius.xsAll,
              border: Border.all(color: palette.outlineVariant),
            ),
            alignment: Alignment.center,
            child: Text(
              keys[index],
              style: TomathicsTypography.code.copyWith(
                fontSize: 11,
                color: palette.onSurface,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
