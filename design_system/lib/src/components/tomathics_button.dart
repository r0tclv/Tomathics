import 'package:flutter/material.dart';

import '../tokens/tomathics_radius.dart';

enum TomathicsButtonVariant { primary, secondary, outline, quiet, danger }

/// Consistent action button with an optional leading icon.
class TomathicsButton extends StatelessWidget {
  const TomathicsButton({
    required this.label,
    required this.onPressed,
    this.variant = TomathicsButtonVariant.primary,
    this.icon,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final TomathicsButtonVariant variant;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = switch (variant) {
      TomathicsButtonVariant.primary => FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      TomathicsButtonVariant.secondary => FilledButton.styleFrom(
        backgroundColor: colors.secondary,
        foregroundColor: colors.onSecondary,
      ),
      TomathicsButtonVariant.outline => OutlinedButton.styleFrom(
        foregroundColor: colors.onSurface,
        side: BorderSide(color: colors.outline),
      ),
      TomathicsButtonVariant.quiet => TextButton.styleFrom(
        foregroundColor: colors.primary,
      ),
      TomathicsButtonVariant.danger => FilledButton.styleFrom(
        backgroundColor: colors.error,
        foregroundColor: colors.onError,
      ),
    };
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );
    final size = compact ? const Size(40, 36) : const Size(48, 44);

    return switch (variant) {
      TomathicsButtonVariant.primary ||
      TomathicsButtonVariant.secondary ||
      TomathicsButtonVariant.danger => FilledButton(
        onPressed: onPressed,
        style: style.copyWith(
          minimumSize: WidgetStatePropertyAll(size),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: TomathicsRadius.mdAll),
          ),
        ),
        child: content,
      ),
      TomathicsButtonVariant.outline => OutlinedButton(
        onPressed: onPressed,
        style: style.copyWith(
          minimumSize: WidgetStatePropertyAll(size),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: TomathicsRadius.mdAll),
          ),
        ),
        child: content,
      ),
      TomathicsButtonVariant.quiet => TextButton(
        onPressed: onPressed,
        style: style.copyWith(minimumSize: WidgetStatePropertyAll(size)),
        child: content,
      ),
    };
  }
}
