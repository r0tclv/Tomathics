import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_spacing.dart';
import '../tokens/tomathics_typography.dart';
import 'tomathics_status_badge.dart';

enum AutomationNodeKind { scene, condition, action, wait, flow }

/// Node primitive for the visual automation editor.
class AutomationNodeCard extends StatelessWidget {
  const AutomationNodeCard({
    required this.title,
    required this.kind,
    this.subtitle,
    this.status,
    this.selected = false,
    this.hasInput = true,
    this.hasOutput = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final AutomationNodeKind kind;
  final TomathicsStatus? status;
  final bool selected;
  final bool hasInput;
  final bool hasOutput;

  @override
  Widget build(BuildContext context) {
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final palette = Theme.of(context).colorScheme;
    final (accent, icon, kindLabel) = switch (kind) {
      AutomationNodeKind.scene => (
        semantic.nodeScene,
        Icons.crop_free_rounded,
        'CENA',
      ),
      AutomationNodeKind.condition => (
        semantic.nodeCondition,
        Icons.rule_rounded,
        'CONDIÇÃO',
      ),
      AutomationNodeKind.action => (
        semantic.nodeAction,
        Icons.touch_app_rounded,
        'AÇÃO',
      ),
      AutomationNodeKind.wait => (
        semantic.nodeWait,
        Icons.hourglass_bottom_rounded,
        'ESPERA',
      ),
      AutomationNodeKind.flow => (
        semantic.nodeFlow,
        Icons.account_tree_rounded,
        'FLUXO',
      ),
    };
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 238,
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: TomathicsRadius.mdAll,
            border: Border.all(
              color: selected ? palette.primary : palette.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.16),
                      blurRadius: 18,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(TomathicsRadius.md),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(TomathicsSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 16, color: accent),
                        const SizedBox(width: TomathicsSpacing.sm),
                        Expanded(
                          child: Text(
                            kindLabel,
                            style: TomathicsTypography.labelSmall.copyWith(
                              color: accent,
                            ),
                          ),
                        ),
                        if (status != null)
                          TomathicsStatusBadge(status: status!, compact: true),
                      ],
                    ),
                    const SizedBox(height: TomathicsSpacing.sm),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: TomathicsSpacing.xs),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: palette.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (hasInput)
          Positioned(
            left: -5,
            top: 30,
            child: _Port(color: palette.onSurfaceVariant),
          ),
        if (hasOutput)
          Positioned(
            right: -5,
            top: 30,
            child: _Port(color: accent),
          ),
      ],
    );
  }
}

class _Port extends StatelessWidget {
  const _Port({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}
