import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';

enum TomathicsBannerTone { info, success, warning, danger }

/// Inline feedback banner for connection, validation, and execution notices.
class TomathicsMessageBanner extends StatelessWidget {
  const TomathicsMessageBanner({
    required this.title,
    required this.message,
    required this.tone,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    super.key,
  }) : assert(
         actionLabel == null || onAction != null,
         'Provide onAction when actionLabel is set.',
       );

  final String title;
  final String message;
  final TomathicsBannerTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final (foreground, background, icon) = switch (tone) {
      TomathicsBannerTone.info => (
        semantic.info,
        semantic.infoContainer,
        Icons.info_outline_rounded,
      ),
      TomathicsBannerTone.success => (
        semantic.success,
        semantic.successContainer,
        Icons.check_circle_outline_rounded,
      ),
      TomathicsBannerTone.warning => (
        semantic.warning,
        semantic.warningContainer,
        Icons.warning_amber_rounded,
      ),
      TomathicsBannerTone.danger => (
        semantic.danger,
        semantic.dangerContainer,
        Icons.error_outline_rounded,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(TomathicsSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: TomathicsRadius.mdAll,
        border: Border.all(color: foreground.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: TomathicsSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: foreground,
                  ),
                ),
                const SizedBox(height: TomathicsSpacing.xxs),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: foreground,
                  ),
                ),
                if (actionLabel case final label?) ...[
                  const SizedBox(height: TomathicsSpacing.xs),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: foreground,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 36),
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(label),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              tooltip: 'Dispensar aviso',
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close_rounded, color: foreground, size: 18),
            ),
        ],
      ),
    );
  }
}
