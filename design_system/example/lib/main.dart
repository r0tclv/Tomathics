import 'package:flutter/material.dart';
import 'package:tomathics_design_system/tomathics_design_system.dart';

import 'login_demo_page.dart';

void main() => runApp(const TomathicsGalleryApp());

class TomathicsGalleryApp extends StatefulWidget {
  const TomathicsGalleryApp({super.key});

  @override
  State<TomathicsGalleryApp> createState() => _TomathicsGalleryAppState();
}

class _TomathicsGalleryAppState extends State<TomathicsGalleryApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomathics · Design system',
      debugShowCheckedModeBanner: false,
      theme: TomathicsTheme.light(),
      darkTheme: TomathicsTheme.dark(),
      themeMode: _themeMode,
      home: GalleryPage(
        isDark: _themeMode == ThemeMode.dark,
        onThemeChanged: (dark) => setState(
          () => _themeMode = dark ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    required this.isDark,
    required this.onThemeChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _showLoginDemo = false;

  @override
  Widget build(BuildContext context) {
    if (_showLoginDemo) {
      return LoginDemoPage(
        isDark: widget.isDark,
        onThemeChanged: widget.onThemeChanged,
        onReturn: () => setState(() => _showLoginDemo = false),
      );
    }

    final palette = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Row(
        children: [
          if (width >= TomathicsLayout.expandedBreakpoint)
            _Sidebar(
              isDark: widget.isDark,
              loginSelected: false,
              onOpenLoginDemo: () => setState(() => _showLoginDemo = true),
            ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  isDark: widget.isDark,
                  onThemeChanged: widget.onThemeChanged,
                  onOpenLoginDemo: () => setState(() => _showLoginDemo = true),
                  showLoginAction: width < TomathicsLayout.expandedBreakpoint,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(
                      width < TomathicsLayout.compactBreakpoint ? 16 : 32,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: TomathicsLayout.wideContentMax,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PageHeading(isDark: widget.isDark),
                            const SizedBox(height: 32),
                            _Section(
                              title: 'Cores e estados',
                              subtitle:
                                  'Uma linguagem visual para ler o sistema de relance.',
                              child: const _ColorSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Editor de fluxo',
                              subtitle:
                                  'Canvas com grade e conexões para o mapa de dependências.',
                              child: _FlowSamples(),
                            ),
                            const SizedBox(height: 24),
                            _Section(
                              title: 'Hierarquia tipográfica',
                              subtitle:
                                  'Sans-serif nativa para interface; monoespaçada para dados.',
                              child: const _TypeSamples(),
                            ),
                            const SizedBox(height: 24),
                            _Section(
                              title: 'Componentes de produto',
                              subtitle:
                                  'Receitas, grafo de automação e progresso de objetivos.',
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (constraints.maxWidth < 700) {
                                    return const Column(
                                      children: [
                                        _ProductSamples(),
                                        SizedBox(height: 16),
                                        _RecipeSamples(),
                                      ],
                                    );
                                  }
                                  return const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: _ProductSamples()),
                                      SizedBox(width: 16),
                                      Expanded(child: _RecipeSamples()),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            _Section(
                              title: 'Ações e superfícies',
                              subtitle:
                                  'Ações principais, secundárias e estados de feedback.',
                              child: const _ActionSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Todos os estados',
                              subtitle:
                                  'Estados de execução, conexão, vazio, busca, erro e permissão.',
                              child: _StateSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Formulários e controles',
                              subtitle:
                                  'Campos, validação, busca, seleção, toggles e ajustes.',
                              child: _InputSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Métricas e carregamento',
                              subtitle:
                                  'Resumo operacional e placeholders para conteúdo assíncrono.',
                              child: _MetricSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Iconografia',
                              subtitle:
                                  'Catálogo nomeado para navegação, nós, estados, alvos e ações.',
                              child: _IconSamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Diálogos e notificações',
                              subtitle:
                                  'Exemplos executáveis de snackbar, confirmação e painel inferior.',
                              child: _OverlaySamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Atividade, tabelas e atalhos',
                              subtitle:
                                  'Histórico de execução, receitas em tabela e comandos do editor.',
                              child: _ActivitySamples(),
                            ),
                            const SizedBox(height: 24),
                            const _Section(
                              title: 'Escalas e layouts',
                              subtitle:
                                  'Ritmo, cantos, elevação e breakpoints para manter consistência.',
                              child: _ScaleSamples(),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'TOMATHICS  /  DESIGN SYSTEM  /  V0.1',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: palette.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.isDark,
    required this.loginSelected,
    required this.onOpenLoginDemo,
  });

  final bool isDark;
  final bool loginSelected;
  final VoidCallback onOpenLoginDemo;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Container(
      width: TomathicsLayout.desktopSidebar,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(right: BorderSide(color: palette.outlineVariant)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: palette.primary,
                  borderRadius: TomathicsRadius.mdAll,
                ),
                child: Icon(
                  Icons.account_tree_rounded,
                  size: 20,
                  color: palette.onPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Text('tomathics', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 36),
          _NavItem(
            icon: Icons.login_rounded,
            label: 'Login (demo)',
            selected: loginSelected,
            onTap: onOpenLoginDemo,
          ),
          _NavItem(
            icon: Icons.dashboard_outlined,
            label: 'Visão geral',
            selected: true,
          ),
          const _NavItem(icon: Icons.hub_outlined, label: 'Editor de nós'),
          const _NavItem(icon: Icons.account_tree_outlined, label: 'Receitas'),
          const _NavItem(icon: Icons.monitor_heart_outlined, label: 'Monitor'),
          const _NavItem(icon: Icons.bolt_outlined, label: 'Rotinas'),
          const Spacer(),
          Text(
            isDark ? 'DARK MODE' : 'LIGHT MODE',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: palette.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Editor visual de automações',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? palette.primaryContainer : Colors.transparent,
        borderRadius: TomathicsRadius.smAll,
        child: ListTile(
          dense: true,
          onTap: onTap,
          leading: Icon(
            icon,
            size: 19,
            color: selected ? palette.primary : palette.onSurfaceVariant,
          ),
          title: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? palette.primary : palette.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.isDark,
    required this.onThemeChanged,
    required this.onOpenLoginDemo,
    required this.showLoginAction,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onOpenLoginDemo;
  final bool showLoginAction;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final compact =
        MediaQuery.sizeOf(context).width < TomathicsLayout.compactBreakpoint;
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 24),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.grid_view_rounded, size: 18, color: palette.primary),
          const SizedBox(width: 10),
          Text('Design system', style: Theme.of(context).textTheme.titleSmall),
          const Spacer(),
          if (showLoginAction) ...[
            IconButton(
              key: const ValueKey('open-login-demo'),
              onPressed: onOpenLoginDemo,
              tooltip: 'Demonstração de login',
              icon: const Icon(Icons.login_rounded),
            ),
            const SizedBox(width: 4),
          ],
          if (!compact) ...[
            Text(
              'TEMA',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: palette.onSurfaceVariant),
            ),
            const SizedBox(width: 8),
          ],
          Icon(
            isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            size: 18,
            color: palette.onSurfaceVariant,
          ),
          Switch(
            key: const ValueKey('theme-mode-switch'),
            value: isDark,
            onChanged: onThemeChanged,
          ),
        ],
      ),
    );
  }
}

class _PageHeading extends StatelessWidget {
  const _PageHeading({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SISTEMA DE DESIGN  /  2026',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: palette.secondary),
              ),
              const SizedBox(height: 10),
              Text(
                'Construa fluxos.\nEnxergue o sistema.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Uma linguagem visual para transformar automações em algo claro, observável e seu.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: palette.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (MediaQuery.sizeOf(context).width >= 600)
          _CanvasMotif(isDark: isDark),
      ],
    );
  }
}

class _CanvasMotif extends StatelessWidget {
  const _CanvasMotif({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = TomathicsTheme.semantic(context);
    return Container(
      width: 190,
      height: 110,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: TomathicsRadius.lgAll,
        border: Border.all(color: palette.outlineVariant),
      ),
      child: CustomPaint(
        painter: _MiniGraphPainter(
          grid: semantic.canvasGrid,
          connector: palette.secondary,
          nodeA: palette.primary,
          nodeB: semantic.nodeAction,
          nodeC: semantic.nodeCondition,
        ),
        child: Center(
          child: Icon(
            Icons.account_tree_rounded,
            color: palette.onSurface.withValues(alpha: 0.1),
            size: 42,
          ),
        ),
      ),
    );
  }
}

class _MiniGraphPainter extends CustomPainter {
  const _MiniGraphPainter({
    required this.grid,
    required this.connector,
    required this.nodeA,
    required this.nodeB,
    required this.nodeC,
  });

  final Color grid;
  final Color connector;
  final Color nodeA;
  final Color nodeB;
  final Color nodeC;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (double x = 12; x < size.width; x += 16) {
      for (double y = 12; y < size.height; y += 16) {
        canvas.drawCircle(Offset(x, y), 1, gridPaint);
      }
    }
    final line = Paint()
      ..color = connector
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(48, 38)
      ..cubicTo(80, 38, 72, 72, 105, 72)
      ..cubicTo(130, 72, 124, 42, 150, 42);
    canvas.drawPath(path, line);
    for (final (x, y, color) in <(double, double, Color)>[
      (48, 38, nodeA),
      (105, 72, nodeB),
      (150, 42, nodeC),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: 30, height: 24),
          const Radius.circular(6),
        ),
        Paint()..color = color,
      );
      canvas.drawCircle(
        Offset(x + 15, y),
        3,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniGraphPainter oldDelegate) =>
      grid != oldDelegate.grid ||
      connector != oldDelegate.connector ||
      nodeA != oldDelegate.nodeA ||
      nodeB != oldDelegate.nodeB ||
      nodeC != oldDelegate.nodeC;
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _ColorSamples extends StatelessWidget {
  const _ColorSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final semantic = TomathicsTheme.semantic(context);
    final samples = <(String, Color)>[
      ('Primária', palette.primary),
      ('Primária · fundo', palette.primaryContainer),
      ('Ciano', palette.secondary),
      ('Fundo', palette.surface),
      ('Superfície', palette.surfaceContainerHighest),
      ('Superfície baixa', palette.surfaceContainerLow),
      ('Texto principal', palette.onSurface),
      ('Texto secundário', palette.onSurfaceVariant),
      ('Borda', palette.outlineVariant),
      ('Informação', semantic.info),
      ('Concluído', semantic.success),
      ('Atenção', semantic.warning),
      ('Falha', semantic.danger),
      ('Neutro', semantic.neutral),
      ('Gatilho', semantic.nodeTrigger),
      ('Cena', semantic.nodeScene),
      ('Observar', semantic.nodeObserve),
      ('Condição', semantic.nodeCondition),
      ('Ação', semantic.nodeAction),
      ('Espera', semantic.nodeWait),
      ('Repetir', semantic.nodeRepeat),
      ('Fluxo', semantic.nodeFlow),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final (label, color) in samples)
          Container(
            width: 112,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: TomathicsRadius.mdAll,
              border: Border.all(color: palette.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: TomathicsRadius.smAll,
                  ),
                ),
                const SizedBox(height: 8),
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(
                  '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                  style: TomathicsTypography.code.copyWith(
                    fontSize: 10,
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TypeSamples extends StatelessWidget {
  const _TypeSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return TomathicsPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypeSample(
            role: 'Display · 36 / 700',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          _TypeSample(
            role: 'Headline large · 30 / 700',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          _TypeSample(
            role: 'Headline medium · 24 / 600',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          _TypeSample(
            role: 'Headline small · 20 / 600',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          _TypeSample(
            role: 'Title large · 18 / 600',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _TypeSample(
            role: 'Title medium · 16 / 600',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _TypeSample(
            role: 'Title small · 14 / 600',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          _TypeSample(
            role: 'Body large · 16 / 400',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          _TypeSample(
            role: 'Body medium · 14 / 400',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.onSurfaceVariant),
          ),
          _TypeSample(
            role: 'Body small · 12 / 400',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.onSurfaceVariant),
          ),
          _TypeSample(
            role: 'Label large · 14 / 600',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          _TypeSample(
            role: 'Label medium · 12 / 600',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          _TypeSample(
            role: 'Label small · 11 / 700',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'OBJETIVO #12  ·  10/30  ·  00:03:20',
            style: TomathicsTypography.code.copyWith(color: palette.secondary),
          ),
        ],
      ),
    );
  }
}

class _TypeSample extends StatelessWidget {
  const _TypeSample({required this.role, required this.style});

  final String role;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TomathicsSpacing.sm),
      child: Text('$role  ·  Tomathics', style: style),
    );
  }
}

class _ProductSamples extends StatelessWidget {
  const _ProductSamples();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ObjectiveProgressCard(
          title: 'Objetivo · 10 sanduíches',
          completed: 4,
          total: 10,
          estimate: '~ 12 min',
          lastRead: 'Última leitura da tela há 40 s',
          status: TomathicsStatus.running,
        ),
      ],
    );
  }
}

class _FlowSamples extends StatelessWidget {
  const _FlowSamples();

  @override
  Widget build(BuildContext context) {
    return TomathicsPanel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: TomathicsRadius.lgAll,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: AutomationCanvas(
            width: 820,
            height: 190,
            connections: const [
              AutomationCanvasConnection(from: 'scan', to: 'check'),
              AutomationCanvasConnection(from: 'check', to: 'bake'),
            ],
            nodes: const [
              AutomationCanvasNode(
                id: 'scan',
                position: Offset(24, 46),
                child: AutomationNodeCard(
                  title: 'Ler estoque',
                  subtitle: 'Capturar tela',
                  kind: AutomationNodeKind.scene,
                  hasInput: false,
                ),
              ),
              AutomationCanvasNode(
                id: 'check',
                position: Offset(290, 20),
                child: AutomationNodeCard(
                  title: 'Verificar trigo',
                  subtitle: 'Estoque ≥ 3',
                  kind: AutomationNodeKind.condition,
                  selected: true,
                ),
              ),
              AutomationCanvasNode(
                id: 'bake',
                position: Offset(556, 46),
                child: AutomationNodeCard(
                  title: 'Produzir pão',
                  subtitle: 'Padaria · ×10',
                  kind: AutomationNodeKind.action,
                  status: TomathicsStatus.running,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeSamples extends StatelessWidget {
  const _RecipeSamples();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecipeContractCard(
          title: 'Fazer pão',
          location: 'Alvo: Hay Day · Padaria',
          consumes: const ['3 × Trigo', '1 vaga na máquina'],
          produces: const ['1 × Pão'],
        ),
        const SizedBox(height: 16),
        TomathicsPanel(
          title: 'Etapas do plano',
          subtitle: 'Dependências para o objetivo atual',
          child: const Column(
            children: [
              _PlanStep(
                title: 'Colher trigo',
                detail: '30 unidades reservadas',
                status: TomathicsStatus.completed,
              ),
              _PlanStep(
                title: 'Produzir pão',
                detail: 'Padaria ocupada · 3:20',
                status: TomathicsStatus.running,
              ),
              _PlanStep(
                title: 'Montar sanduíches',
                detail: 'Aguardando pão',
                status: TomathicsStatus.waiting,
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.title,
    required this.detail,
    required this.status,
    this.last = false,
  });

  final String title;
  final String detail;
  final TomathicsStatus status;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            last ? Icons.subdirectory_arrow_right_rounded : Icons.route_rounded,
            size: 16,
            color: palette.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: palette.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TomathicsStatusBadge(status: status, compact: true),
        ],
      ),
    );
  }
}

class _ActionSamples extends StatelessWidget {
  const _ActionSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return TomathicsPanel(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const TomathicsButton(
            label: 'Novo objetivo',
            icon: Icons.add_rounded,
            onPressed: _noop,
          ),
          const TomathicsButton(
            label: 'Pré-visualizar plano',
            variant: TomathicsButtonVariant.outline,
            icon: Icons.account_tree_outlined,
            onPressed: _noop,
          ),
          const TomathicsButton(
            label: 'Pausar rotina',
            variant: TomathicsButtonVariant.quiet,
            icon: Icons.pause_rounded,
            onPressed: _noop,
          ),
          const TomathicsButton(
            label: 'Cancelar',
            variant: TomathicsButtonVariant.danger,
            icon: Icons.stop_rounded,
            onPressed: _noop,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: palette.surfaceContainerLow,
              borderRadius: TomathicsRadius.smAll,
            ),
            child: Text(
              'Foco · contorno visível',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _StateSamples extends StatelessWidget {
  const _StateSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TomathicsPanel(
          title: 'Estados do motor',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in TomathicsStatus.values)
                TomathicsStatusBadge(status: status),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth < 620
                ? constraints.maxWidth
                : (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final state in TomathicsViewState.values)
                  SizedBox(
                    width: itemWidth,
                    height: 300,
                    child: TomathicsPanel(
                      padding: EdgeInsets.zero,
                      child: TomathicsStateView(
                        state: state,
                        actionLabel: switch (state) {
                          TomathicsViewState.loading => null,
                          TomathicsViewState.empty => 'Criar receita',
                          TomathicsViewState.noResults => 'Limpar busca',
                          TomathicsViewState.error => 'Tentar novamente',
                          TomathicsViewState.offline => 'Ver conexão',
                          TomathicsViewState.permissionRequired =>
                            'Abrir permissões',
                        },
                        onAction: _noop,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        for (final tone in TomathicsBannerTone.values) ...[
          TomathicsMessageBanner(
            title: switch (tone) {
              TomathicsBannerTone.info => 'Leitura da tela',
              TomathicsBannerTone.success => 'Objetivo concluído',
              TomathicsBannerTone.warning => 'Receita bloqueada',
              TomathicsBannerTone.danger => 'Motor indisponível',
            },
            message: switch (tone) {
              TomathicsBannerTone.info => 'Estoque atualizado há 40 segundos.',
              TomathicsBannerTone.success =>
                'Os 10 sanduíches foram produzidos.',
              TomathicsBannerTone.warning =>
                'Falta queijo e nenhuma receita o produz.',
              TomathicsBannerTone.danger =>
                'A conexão com o computador foi interrompida.',
            },
            tone: tone,
            actionLabel: tone == TomathicsBannerTone.warning
                ? 'Ver dependências'
                : null,
            onAction: _noop,
          ),
          if (tone != TomathicsBannerTone.danger)
            const SizedBox(height: TomathicsSpacing.sm),
        ],
        const SizedBox(height: 16),
        Text('Variações de nó', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final kind in AutomationNodeKind.values) ...[
                AutomationNodeCard(
                  title: switch (kind) {
                    AutomationNodeKind.trigger => 'Quando ficar pronto',
                    AutomationNodeKind.scene => 'Ler tela',
                    AutomationNodeKind.observe => 'Localizar padaria',
                    AutomationNodeKind.condition => 'Estoque ≥ 3',
                    AutomationNodeKind.action => 'Colher trigo',
                    AutomationNodeKind.wait => 'Aguardar 3:20',
                    AutomationNodeKind.repeat => 'Manter estoque',
                    AutomationNodeKind.flow => 'Executar receita',
                  },
                  kind: kind,
                  hasInput: kind != AutomationNodeKind.trigger,
                  hasOutput: kind != AutomationNodeKind.action,
                  status: switch (kind) {
                    AutomationNodeKind.trigger => TomathicsStatus.idle,
                    AutomationNodeKind.scene => TomathicsStatus.completed,
                    AutomationNodeKind.observe => TomathicsStatus.running,
                    AutomationNodeKind.condition => TomathicsStatus.attention,
                    AutomationNodeKind.action => TomathicsStatus.failed,
                    AutomationNodeKind.wait => TomathicsStatus.waiting,
                    AutomationNodeKind.repeat => TomathicsStatus.paused,
                    AutomationNodeKind.flow => TomathicsStatus.blocked,
                  },
                ),
                const SizedBox(width: 20),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A idade da leitura é um estado do produto: dados antigos nunca devem parecer atuais.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: palette.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _InputSamples extends StatefulWidget {
  const _InputSamples();

  @override
  State<_InputSamples> createState() => _InputSamplesState();
}

class _InputSamplesState extends State<_InputSamples> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController(text: 'Hay Day · Fazenda');
  String _selectedLayout = 'Editor';
  bool _keepRunning = true;
  bool _showOnlyActive = true;
  bool _verifyBeforeRun = true;
  double _scanInterval = 3;
  String _selectedFilter = 'Ativas';
  bool _hasErrors = false;

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return TomathicsPanel(
      title: 'Configurar alvo',
      subtitle:
          'Exemplos editáveis; valide campos antes de iniciar uma receita.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 620 ? 1 : 2;
                final fieldWidth =
                    (constraints.maxWidth - (columns - 1) * 16) / columns;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: TomathicsTextField(
                        label: 'Nome do alvo',
                        controller: _targetController,
                        hint: 'Ex.: Fazenda principal',
                        helperText: 'Identifique o app ou a janela.',
                        required: true,
                        prefixIcon: const Icon(Icons.label_outline_rounded),
                        textInputAction: TextInputAction.next,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Informe um nome para o alvo.'
                            : null,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TomathicsTextField(
                        label: 'Janela ou endereço',
                        hint: 'http://localhost:8080',
                        prefixIcon: const Icon(Icons.link_rounded),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TomathicsTextField(
              label: 'Buscar receita',
              hint: 'Buscar por nome, ingrediente ou alvo',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                tooltip: 'Filtros',
                onPressed: _noop,
                icon: const Icon(Icons.filter_list_rounded),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: const Text('Ativas'),
                  avatar: const Icon(Icons.play_arrow_rounded, size: 16),
                  selected: _showOnlyActive,
                  onSelected: (value) => setState(() {
                    _showOnlyActive = value;
                  }),
                ),
                const InputChip(
                  label: Text('Hay Day'),
                  avatar: Icon(Icons.phone_android_rounded, size: 16),
                  onDeleted: _noop,
                ),
                ChoiceChip(
                  label: const Text('Pausadas'),
                  selected: _selectedFilter == 'Pausadas',
                  onSelected: (value) => setState(() {
                    _selectedFilter = value ? 'Pausadas' : 'Ativas';
                  }),
                ),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Editor', label: Text('Editor')),
                    ButtonSegment(value: 'Monitor', label: Text('Monitor')),
                  ],
                  selected: {_selectedLayout},
                  onSelectionChanged: (value) =>
                      setState(() => _selectedLayout = value.first),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Manter rotina ativa'),
              subtitle: const Text('Executar até ser pausada.'),
              value: _keepRunning,
              onChanged: (value) => setState(() => _keepRunning = value),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Revisar plano antes de executar'),
              value: _verifyBeforeRun,
              onChanged: (value) =>
                  setState(() => _verifyBeforeRun = value ?? false),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Intervalo de leitura',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Text(
                  '${_scanInterval.round()} s',
                  style: TomathicsTypography.code.copyWith(
                    color: palette.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _scanInterval,
              min: 1,
              max: 10,
              divisions: 9,
              label: '${_scanInterval.round()} s',
              onChanged: (value) => setState(() => _scanInterval = value),
            ),
            if (_hasErrors)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Revise os campos obrigatórios antes de continuar.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: palette.error),
                ),
              ),
            TomathicsButton(
              label: 'Validar formulário',
              icon: Icons.check_rounded,
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                setState(() => _hasErrors = !isValid);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricSamples extends StatelessWidget {
  const _MetricSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            TomathicsMetricCard(
              label: 'Objetivos ativos',
              value: '04',
              icon: Icons.flag_outlined,
              detail: '+2 nesta sessão',
              trend: TomathicsMetricTrend.positive,
            ),
            TomathicsMetricCard(
              label: 'Rotinas',
              value: '08',
              icon: Icons.bolt_outlined,
              detail: '3 aguardando',
            ),
            TomathicsMetricCard(
              label: 'Falhas hoje',
              value: '01',
              icon: Icons.error_outline_rounded,
              detail: '1 requer atenção',
              trend: TomathicsMetricTrend.negative,
            ),
          ],
        ),
        const SizedBox(height: 16),
        TomathicsPanel(
          title: 'Carregando receitas',
          subtitle:
              'Placeholders reservam o espaço e reduzem mudanças de layout.',
          child: Row(
            children: [
              TomathicsSkeleton(
                width: 44,
                height: 44,
                radius: TomathicsRadius.pill,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TomathicsSkeleton(width: 190, height: 14),
                    SizedBox(height: 10),
                    TomathicsSkeleton(width: 260, height: 10),
                  ],
                ),
              ),
              Icon(
                Icons.hourglass_top_rounded,
                color: palette.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconSamples extends StatelessWidget {
  const _IconSamples();

  @override
  Widget build(BuildContext context) {
    final groups = <(String, List<(String, IconData)>)>[
      (
        'NAVEGAÇÃO',
        [
          ('Visão geral', TomathicsIcons.navigation.overview),
          ('Editor', TomathicsIcons.navigation.editor),
          ('Receitas', TomathicsIcons.navigation.recipes),
          ('Objetivos', TomathicsIcons.navigation.objectives),
          ('Monitor', TomathicsIcons.navigation.monitor),
          ('Rotinas', TomathicsIcons.navigation.routines),
          ('Alvos', TomathicsIcons.navigation.targets),
          ('Cenas', TomathicsIcons.navigation.scenes),
          ('Ajustes', TomathicsIcons.navigation.settings),
          ('Ajuda', TomathicsIcons.navigation.help),
          ('Avisos', TomathicsIcons.navigation.notifications),
          ('Histórico', TomathicsIcons.navigation.history),
        ],
      ),
      (
        'NÓS',
        [
          ('Gatilho', TomathicsIcons.nodes.trigger),
          ('Cena', TomathicsIcons.nodes.scene),
          ('Observar', TomathicsIcons.nodes.observe),
          ('Condição', TomathicsIcons.nodes.condition),
          ('Ação', TomathicsIcons.nodes.action),
          ('Espera', TomathicsIcons.nodes.wait),
          ('Repetir', TomathicsIcons.nodes.repeat),
          ('Fluxo', TomathicsIcons.nodes.flow),
          ('Ramificação', TomathicsIcons.nodes.branch),
          ('Variável', TomathicsIcons.nodes.variable),
        ],
      ),
      (
        'ESTADOS',
        [
          ('Executando', TomathicsIcons.states.running),
          ('Concluído', TomathicsIcons.states.completed),
          ('Aguardando', TomathicsIcons.states.waiting),
          ('Pausado', TomathicsIcons.states.paused),
          ('Atenção', TomathicsIcons.states.attention),
          ('Falhou', TomathicsIcons.states.failed),
          ('Bloqueado', TomathicsIcons.states.blocked),
          ('Desconectado', TomathicsIcons.states.disconnected),
          ('Desatualizado', TomathicsIcons.states.stale),
          ('Inativo', TomathicsIcons.states.idle),
          ('Carregando', TomathicsIcons.states.loading),
        ],
      ),
      (
        'ALVOS E RECURSOS',
        [
          ('Desktop', TomathicsIcons.targets.desktop),
          ('Navegador', TomathicsIcons.targets.browser),
          ('Emulador', TomathicsIcons.targets.emulator),
          ('Janela', TomathicsIcons.targets.window),
          ('Conectado', TomathicsIcons.targets.connected),
          ('Desconectado', TomathicsIcons.targets.disconnected),
          ('Capturar', TomathicsIcons.targets.capture),
          ('Localizar', TomathicsIcons.targets.locate),
          ('Entrada', TomathicsIcons.resources.input),
          ('Saída', TomathicsIcons.resources.output),
          ('Estoque', TomathicsIcons.resources.inventory),
          ('Tempo', TomathicsIcons.resources.time),
          ('Máquina', TomathicsIcons.resources.machine),
          ('Cena-alvo', TomathicsIcons.resources.scene),
          ('Entidade', TomathicsIcons.resources.entity),
          ('Dependência', TomathicsIcons.resources.dependency),
        ],
      ),
      (
        'AÇÕES',
        [
          ('Adicionar', TomathicsIcons.actions.add),
          ('Editar', TomathicsIcons.actions.edit),
          ('Duplicar', TomathicsIcons.actions.duplicate),
          ('Excluir', TomathicsIcons.actions.delete),
          ('Buscar', TomathicsIcons.actions.search),
          ('Filtrar', TomathicsIcons.actions.filter),
          ('Ordenar', TomathicsIcons.actions.sort),
          ('Executar', TomathicsIcons.actions.play),
          ('Pausar', TomathicsIcons.actions.pause),
          ('Parar', TomathicsIcons.actions.stop),
          ('Atualizar', TomathicsIcons.actions.refresh),
          ('Mais', TomathicsIcons.actions.more),
          ('Voltar', TomathicsIcons.actions.back),
          ('Avançar', TomathicsIcons.actions.forward),
          ('Expandir', TomathicsIcons.actions.expand),
          ('Abrir link', TomathicsIcons.actions.externalLink),
          ('Fechar', TomathicsIcons.actions.close),
          ('Mostrar', TomathicsIcons.actions.visibility),
          ('Ocultar', TomathicsIcons.actions.visibilityOff),
        ],
      ),
    ];

    return Column(
      children: [
        for (final (title, icons) in groups) ...[
          TomathicsPanel(
            title: title,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (label, icon) in icons)
                  SizedBox(
                    width: 140,
                    child: Tooltip(
                      message: label,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLow,
                          borderRadius: TomathicsRadius.smAll,
                        ),
                        child: Row(
                          children: [
                            Icon(icon, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _OverlaySamples extends StatelessWidget {
  const _OverlaySamples();

  @override
  Widget build(BuildContext context) {
    return TomathicsPanel(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          TomathicsButton(
            label: 'Mostrar snackbar',
            icon: Icons.notifications_outlined,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Plano salvo com sucesso.'),
                action: SnackBarAction(label: 'DESFAZER', onPressed: _noop),
              ),
            ),
          ),
          TomathicsButton(
            label: 'Abrir confirmação',
            variant: TomathicsButtonVariant.outline,
            icon: Icons.warning_amber_rounded,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                icon: const Icon(Icons.stop_circle_outlined),
                title: const Text('Cancelar objetivo?'),
                content: const Text(
                  'O plano será interrompido. Essa ação não apaga a receita.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continuar'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar objetivo'),
                  ),
                ],
              ),
            ),
          ),
          TomathicsButton(
            label: 'Abrir painel inferior',
            variant: TomathicsButtonVariant.quiet,
            icon: Icons.expand_less_rounded,
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(TomathicsSpacing.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pré-visualização do plano',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text('3 receitas · 30 itens reservados'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Entendi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitySamples extends StatelessWidget {
  const _ActivitySamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TomathicsPanel(
          title: 'Atividade recente',
          subtitle: 'Eventos do motor em ordem cronológica.',
          child: const Column(
            children: [
              TomathicsActivityTile(
                title: 'Pão produzido',
                detail: 'Padaria · objetivo #12 · lote 4/10',
                time: 'há 2 min',
                icon: Icons.task_alt_rounded,
                status: TomathicsStatus.completed,
              ),
              Divider(),
              TomathicsActivityTile(
                title: 'Aguardando espaço',
                detail: 'A máquina está ocupada até 14:32.',
                time: 'há 3 min',
                icon: Icons.hourglass_bottom_rounded,
                status: TomathicsStatus.waiting,
              ),
              Divider(),
              TomathicsActivityTile(
                title: 'Leitura desatualizada',
                detail: 'O estoque não é confirmado há 40 segundos.',
                time: 'há 4 min',
                icon: Icons.visibility_outlined,
                status: TomathicsStatus.stale,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TomathicsPanel(
          title: 'Biblioteca de receitas',
          subtitle: 'Tabela de desktop com estado e última execução.',
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Receita')),
                DataColumn(label: Text('Alvo')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Execuções'), numeric: true),
                DataColumn(label: Text('Última vez')),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('Fazer pão')),
                    DataCell(Text('Hay Day')),
                    DataCell(
                      TomathicsStatusBadge(status: TomathicsStatus.running),
                    ),
                    DataCell(Text('28')),
                    DataCell(Text('há 2 min')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Colher trigo')),
                    DataCell(Text('Hay Day')),
                    DataCell(
                      TomathicsStatusBadge(status: TomathicsStatus.completed),
                    ),
                    DataCell(Text('104')),
                    DataCell(Text('há 5 min')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Montar sanduíche')),
                    DataCell(Text('Hay Day')),
                    DataCell(
                      TomathicsStatusBadge(status: TomathicsStatus.blocked),
                    ),
                    DataCell(Text('0')),
                    DataCell(Text('nunca')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TomathicsPanel(
          title: 'Atalhos do editor',
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: const [
              TomathicsShortcutHint(
                keys: ['Ctrl', 'S'],
                label: 'Salvar receita',
              ),
              TomathicsShortcutHint(keys: ['Ctrl', 'Z'], label: 'Desfazer'),
              TomathicsShortcutHint(
                keys: ['Ctrl', 'Shift', 'Z'],
                label: 'Refazer',
              ),
              TomathicsShortcutHint(keys: ['Ctrl', 'K'], label: 'Buscar nó'),
              TomathicsShortcutHint(keys: ['Delete'], label: 'Remover seleção'),
              TomathicsShortcutHint(
                keys: ['Space', 'Drag'],
                label: 'Mover canvas',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Atalhos são affordances: documente-os em menus e tooltips e permita operação equivalente por mouse e toque.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: palette.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ScaleSamples extends StatelessWidget {
  const _ScaleSamples();

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).colorScheme;
    final spaces = <(String, double)>[
      ('xs', TomathicsSpacing.xs),
      ('sm', TomathicsSpacing.sm),
      ('md', TomathicsSpacing.md),
      ('lg', TomathicsSpacing.lg),
      ('xl', TomathicsSpacing.xl),
      ('xxl', TomathicsSpacing.xxl),
      ('xxxl', TomathicsSpacing.xxxl),
    ];
    final radii = <(String, double)>[
      ('xs', TomathicsRadius.xs),
      ('sm', TomathicsRadius.sm),
      ('md', TomathicsRadius.md),
      ('lg', TomathicsRadius.lg),
      ('xl', TomathicsRadius.xl),
      ('pill', TomathicsRadius.pill),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TomathicsPanel(
          title: 'Espaçamento · grade de 4 px',
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              for (final (label, size) in spaces)
                Column(
                  children: [
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: TomathicsRadius.xsAll,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$label · ${size.toInt()}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TomathicsPanel(
          title: 'Cantos e elevação',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final (label, radius) in radii)
                Container(
                  width: 88,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: palette.outlineVariant),
                    boxShadow: radius == TomathicsRadius.lg
                        ? TomathicsElevation.panel
                        : null,
                  ),
                  child: Text(
                    '$label · ${radius.toInt()}',
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              Container(
                width: 110,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: TomathicsRadius.mdAll,
                  boxShadow: TomathicsElevation.floating,
                ),
                child: Text(
                  'Flutuante',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TomathicsPanel(
          title: 'Breakpoints de layout',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _BreakpointChip(
                name: 'Compacto',
                width: TomathicsLayout.compactBreakpoint,
              ),
              _BreakpointChip(
                name: 'Expandido',
                width: TomathicsLayout.expandedBreakpoint,
              ),
              _BreakpointChip(
                name: 'Largo',
                width: TomathicsLayout.wideBreakpoint,
              ),
              _BreakpointChip(
                name: 'Conteúdo máx.',
                width: TomathicsLayout.wideContentMax,
              ),
              _BreakpointChip(
                name: 'Inspetor',
                width: TomathicsLayout.inspectorPanel,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BreakpointChip extends StatelessWidget {
  const _BreakpointChip({required this.name, required this.width});

  final String name;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.width_wide_rounded, size: 16),
      label: Text('$name · ${width.toInt()} px'),
    );
  }
}

void _noop() {}
