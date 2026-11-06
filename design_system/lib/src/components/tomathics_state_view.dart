import 'package:flutter/material.dart';

import '../theme/tomathics_semantic_colors.dart';
import '../tokens/tomathics_spacing.dart';
import 'tomathics_button.dart';

enum TomathicsViewState {
  loading,
  empty,
  noResults,
  error,
  offline,
  permissionRequired,
}

/// Shared full-area treatment for loading, empty, and recoverable error states.
class TomathicsStateView extends StatelessWidget {
  const TomathicsStateView({
    required this.state,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
    super.key,
  }) : assert(
         actionLabel == null || onAction != null,
         'Provide onAction when actionLabel is set.',
       );

  final TomathicsViewState state;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<TomathicsSemanticColors>()!;
    final (defaultIcon, accent, defaultTitle, defaultMessage) = switch (state) {
      TomathicsViewState.loading => (
        Icons.autorenew_rounded,
        palette.primary,
        'Carregando',
        'Estamos preparando as informações.',
      ),
      TomathicsViewState.empty => (
        Icons.inbox_outlined,
        palette.primary,
        'Tudo começa aqui',
        'Ainda não há itens para mostrar.',
      ),
      TomathicsViewState.noResults => (
        Icons.search_off_rounded,
        semantic.neutral,
        'Nenhum resultado',
        'Tente ajustar os termos ou filtros da busca.',
      ),
      TomathicsViewState.error => (
        Icons.error_outline_rounded,
        semantic.danger,
        'Não foi possível carregar',
        'Ocorreu um problema. Tente novamente.',
      ),
      TomathicsViewState.offline => (
        Icons.cloud_off_outlined,
        semantic.warning,
        'Motor desconectado',
        'Verifique a conexão com o computador e tente de novo.',
      ),
      TomathicsViewState.permissionRequired => (
        Icons.lock_outline_rounded,
        semantic.warning,
        'Permissão necessária',
        'Conceda acesso para continuar.',
      ),
    };

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(TomathicsSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state == TomathicsViewState.loading)
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: accent,
                  ),
                )
              else
                Icon(
                  icon ?? defaultIcon,
                  size: 38,
                  color: accent,
                  semanticLabel: title ?? defaultTitle,
                ),
              const SizedBox(height: TomathicsSpacing.lg),
              Text(
                title ?? defaultTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: TomathicsSpacing.xs),
              Text(
                message ?? defaultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.onSurfaceVariant,
                ),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: TomathicsSpacing.lg),
                TomathicsButton(
                  label: actionLabel!,
                  icon: state == TomathicsViewState.error
                      ? Icons.refresh_rounded
                      : null,
                  onPressed: onAction,
                  variant: state == TomathicsViewState.error
                      ? TomathicsButtonVariant.primary
                      : TomathicsButtonVariant.outline,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
