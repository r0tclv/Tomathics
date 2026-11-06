import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_radius.dart';
import '../tokens/tomathics_typography.dart';

enum TomathicsStatus {
  running,
  completed,
  waiting,
  paused,
  attention,
  failed,
  idle,
}

/// Labeled state with both icon and color, so status is never color-only.
class TomathicsStatusBadge extends StatelessWidget {
  const TomathicsStatusBadge({
    required this.status,
    this.label,
    this.compact = false,
    super.key,
  });

  final TomathicsStatus status;
  final String? label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final (foreground, background, icon, defaultLabel) = switch (status) {
      TomathicsStatus.running => (
        colors.info,
        colors.infoContainer,
        Icons.play_arrow_rounded,
        'Em execução',
      ),
      TomathicsStatus.completed => (
        colors.success,
        colors.successContainer,
        Icons.check_rounded,
        'Concluído',
      ),
      TomathicsStatus.waiting => (
        colors.warning,
        colors.warningContainer,
        Icons.schedule_rounded,
        'Aguardando',
      ),
      TomathicsStatus.paused => (
        colors.neutral,
        colors.neutralContainer,
        Icons.pause_rounded,
        'Pausado',
      ),
      TomathicsStatus.attention => (
        colors.warning,
        colors.warningContainer,
        Icons.priority_high_rounded,
        'Atenção',
      ),
      TomathicsStatus.failed => (
        colors.danger,
        colors.dangerContainer,
        Icons.close_rounded,
        'Falhou',
      ),
      TomathicsStatus.idle => (
        colors.neutral,
        colors.neutralContainer,
        Icons.circle_outlined,
        'Inativo',
      ),
    };
    return Semantics(
      label: label ?? defaultLabel,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: TomathicsRadius.pillAll,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: foreground),
            if (!compact) ...[
              const SizedBox(width: 5),
              Text(
                label ?? defaultLabel,
                style: TomathicsTypography.labelSmall.copyWith(
                  color: foreground,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
