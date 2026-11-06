import 'package:flutter/material.dart';

import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';

/// Standard panel container for inspector, library, and monitor sections.
class TomathicsPanel extends StatelessWidget {
  const TomathicsPanel({
    required this.child,
    this.title,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.all(TomathicsSpacing.panel),
    this.emphasized = false,
    super.key,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry padding;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Material(
      color: emphasized ? palette.surfaceContainerHighest : palette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: TomathicsRadius.lgAll,
        side: BorderSide(
          color: emphasized
              ? palette.primary.withValues(alpha: 0.35)
              : palette.outlineVariant,
        ),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || action != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title case final heading?)
                          Text(
                            heading,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        if (subtitle case final panelSubtitle?) ...[
                          const SizedBox(height: TomathicsSpacing.xs),
                          Text(
                            panelSubtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: palette.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  ?action,
                ],
              ),
              const SizedBox(height: TomathicsSpacing.lg),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
